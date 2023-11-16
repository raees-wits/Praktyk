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
      var newQuestion = Question(questionText: 'New question', answers: ['Correct answer', 'Wrong answer']);

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
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> questionsMap = data['Questions'] as Map<String, dynamic>;

        questionsMap.forEach((key, value) {
          print('Question: $key\nAnswers: $value\n');
        });
        List<Question> loadedQuestions = [];

        data.forEach((questionNumber, questionDetails) {
          if (questionDetails is Map) {
            Map<String, dynamic> innerDetails = questionDetails as Map<String, dynamic>;

            innerDetails.forEach((questionText, answers) {
              if (answers is List) {
                List<String> answerList = List<String>.from(answers);

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
          questions = loadedQuestions;
        });
      } else {
        print("No data exists for the selected category.");
      }

    } catch (error) {
      print("An error occurred: $error");
    }
  }

  Future<void> saveQuestions() async {
    if (selectedCategory == null) {
      return;
    }

    Map<String, List<String>> updatedQuestionsMap = {};

    for (var question in questions) {
      updatedQuestionsMap[question.questionText] = question.answers;
    }


    Map<String, dynamic> updatedData = {'Questions': updatedQuestionsMap};

    try {

      await FirebaseFirestore.instance
          .collection('MultipleChoice')
          .doc(selectedCategory)
          .set(updatedData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Questions updated successfully!')),
      );
    } catch (error) {
      print("An error occurred: $error");
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
      floatingActionButton: FloatingActionButton(
        onPressed: addNewQuestion,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
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
                widget.question.answers.add('New Answer');

                TextEditingController newAnswerController = TextEditingController(text: 'New Answer');

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