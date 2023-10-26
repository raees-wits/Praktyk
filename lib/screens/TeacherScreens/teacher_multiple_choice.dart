import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String questionText;
  List<String> answers; // The first answer is always correct

  Question({required this.questionText, required this.answers});
}

class TeacherMultipleChoice extends StatefulWidget {
  const TeacherMultipleChoice({Key? key}) : super(key: key);

  @override
  _TeacherMultipleChoiceState createState() => _TeacherMultipleChoiceState();
}

class _TeacherMultipleChoiceState extends State<TeacherMultipleChoice> {
  List<Question> questions = [];
  List<String> categories = [];
  String? selectedCategory;
  void addNewQuestion() {
    setState(() {
      // Create a new question with default values.
      var newQuestion = Question(questionText: 'New question', answers: ['Correct answer', 'Wrong answer']);

      // Add the new question to the list of questions.
      questions.add(newQuestion);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      var collectionSnapshot = await FirebaseFirestore.instance.collection('MultipleChoice').get();

      var fetchedCategories = collectionSnapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        categories = fetchedCategories;
      });

    } catch (error) {
      print("An error occurred while fetching categories: $error");
    }
  }

  // Fetch questions based on the selected category
  Future<void> fetchQuestions(String category) async {
    setState(() {
      questions = []; // This ensures all previous questions are removed before fetching new ones.
    });

    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('MultipleChoice')
          .doc(category)
          .get();

      if (docSnapshot.exists) {
        // Extracting the 'questions' map from the document.
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> questionsMap = data['Questions'] as Map<String, dynamic>; // Assuming 'Questions' is the key in the document.

        questionsMap.forEach((key, value) {
          print('Question: $key\nAnswers: $value\n'); // Logging each question and its answers.
        });
        List<Question> loadedQuestions = [];

        // Iterate through the question numbers, i.e., "1", "2", "3", etc.
        data.forEach((questionNumber, questionDetails) {
          // questionDetails should be a map with the question text and answers.
          if (questionDetails is Map) {
            Map<String, dynamic> innerDetails = questionDetails as Map<String, dynamic>;

            // Assuming there's only one entry in this map, as it contains one question and its answers.
            innerDetails.forEach((questionText, answers) {
              // Verify that 'answers' is a List, as expected.
              if (answers is List) {
                List<String> answerList = List<String>.from(answers);

                // Create and add the question.
                loadedQuestions.add(Question(questionText: questionText, answers: answerList));
              } else {
                print("Unexpected data structure encountered for answers.");
              }
            });
          } else {
            print("Unexpected data structure. Expected a Map.");
          }
        });

        setState(() {
          questions = loadedQuestions; // updating the state with the fetched questions
        });
      } else {
        print("No data exists for the selected category.");
      }

    } catch (error) {
      print("An error occurred: $error");
    }
  }

  // Save updated questions to Firestore
  Future<void> saveQuestions() async {
    if (selectedCategory == null) {
      // Handle this case, maybe show an alert dialog
      return;
    }

    // Prepare the structure that you will send to Firestore.
    // This map directly represents your 'Questions' field in the Firestore document.
    Map<String, List<String>> updatedQuestionsMap = {};

    for (var question in questions) {
      updatedQuestionsMap[question.questionText] = question.answers;
    }

    // Prepare the final structure of the document.
    Map<String, dynamic> updatedData = {'Questions': updatedQuestionsMap};

    try {
      // Here you would either update the existing document or set the data in a new document.
      await FirebaseFirestore.instance
          .collection('MultipleChoice')
          .doc(selectedCategory)
          .set(updatedData, SetOptions(merge: true)); // This line ensures that the data is merged with the existing document, not overwrite everything.

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Questions updated successfully!')),
      );
    } catch (error) {
      print("An error occurred: $error");
      // Possibly handle the error more gracefully, e.g., show a dialog to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Questions'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveQuestions,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              hint: Text('Select a Category'),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                  if (newValue != null) {
                    fetchQuestions(newValue);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (ctx, index) {
                return QuestionEditor(
                  question: questions[index],
                  onChanged: (updatedQuestion) {
                    setState(() {
                      questions[index] = updatedQuestion;
                    });
                  },
                  onRemove: () {
                    setState(() {
                      questions.removeAt(index);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton( // Correct property here
        onPressed: addNewQuestion, // Your function to add a new question
        child: Icon(Icons.add),
        backgroundColor: Colors.green, // Or any color you prefer
      ),
    );
  }}


class QuestionEditor extends StatefulWidget {
  final Question question;
  final ValueChanged<Question> onChanged;
  final VoidCallback onRemove;

  QuestionEditor({required this.question, required this.onChanged, required this.onRemove});


  @override
  _QuestionEditorState createState() => _QuestionEditorState();
}
class _QuestionEditorState extends State<QuestionEditor> {
  late TextEditingController questionController;
  late List<TextEditingController> answerControllers;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.question.questionText);
    answerControllers = widget.question.answers.map((a) => TextEditingController(text: a)).toList();
  }

  @override
  void dispose() {
    questionController.dispose();
    answerControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: questionController,
            decoration: InputDecoration(labelText: 'Question'),
            onChanged: (value) {
              widget.onChanged(widget.question..questionText = value);
            },
          ),
          ...answerControllers.asMap().entries.map((entry) {
            int idx = entry.key;
            TextEditingController controller = entry.value;

            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: 'Answer ${idx + 1}'),
                    onChanged: (value) {
                      var updatedAnswers = widget.question.answers..[idx] = value;
                      widget.onChanged(widget.question..answers = updatedAnswers);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      widget.question.answers.removeAt(idx);
                      answerControllers.removeAt(idx);
                      widget.onChanged(widget.question);
                    });
                  },
                ),
              ],
            );
          }).toList(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Add the new answer to the question's answers list.
                widget.question.answers.add('New Answer');

                // Create a new TextEditingController for the new answer.
                TextEditingController newAnswerController = TextEditingController(text: 'New Answer');

                // Add the new controller to the answerControllers list.
                answerControllers.add(newAnswerController);

                // Notify the parent widget about the change in the Question object.
                widget.onChanged(widget.question);
              });
            },
            child: Text('Add Answer'),
          ),

          ElevatedButton(
            onPressed: widget.onRemove,
            child: Text('Remove Question'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}