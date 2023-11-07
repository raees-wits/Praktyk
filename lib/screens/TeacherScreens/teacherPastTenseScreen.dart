import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherPastTenseScreen extends StatefulWidget {
  const TeacherPastTenseScreen({Key? key}) : super(key: key);

  @override
  _TeacherPastTenseScreenState createState() => _TeacherPastTenseScreenState();
}

class _TeacherPastTenseScreenState extends State<TeacherPastTenseScreen> {
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions(); // Load questions when the screen is initialized
  }

  void addNewQuestion() {
    setState(() {
      // Create a new question with default values.
      var newQuestion = Question(
        presentTense: 'New Present Tense',
        pastTense: 'New Past Tense',
      );

      // Add the new question to the list of questions.
      questions.add(newQuestion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Past Tense Questions'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => saveQuestions('PastTense', questions, context),
          ),
        ],
      ),
      body: Column(
        children: [
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
  }

  void loadQuestions() async {
    try {
      final collectionReference = FirebaseFirestore.instance.collection('Tenses');
      final documentReference = collectionReference.doc('Questions');
      final documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final questionsData = data['Questions'] as List<dynamic>;

        final loadedQuestions = questionsData.map((questionMap) {
          return Question(
            presentTense: questionMap['Present Tense'],
            pastTense: questionMap['Past Tense'],
          );
        }).toList();

        setState(() {
          questions = loadedQuestions;
        });
      }
    } catch (error) {
      print("An error occurred while loading questions: $error");
    }
  }
}

class QuestionEditor extends StatefulWidget {
  final Question question;
  final ValueChanged<Question> onChanged;
  final VoidCallback onRemove;

  QuestionEditor({
    required this.question,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  _QuestionEditorState createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  late TextEditingController presentTenseController;
  late TextEditingController pastTenseController;

  @override
  void initState() {
    super.initState();
    presentTenseController = TextEditingController(text: widget.question.presentTense);
    pastTenseController = TextEditingController(text: widget.question.pastTense);
  }

  @override
  void dispose() {
    presentTenseController.dispose();
    pastTenseController.dispose();
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
            controller: presentTenseController,
            decoration: InputDecoration(labelText: 'Present Tense'),
            onChanged: (value) {
              widget.onChanged(widget.question..presentTense = value);
            },
          ),
          TextField(
            controller: pastTenseController,
            decoration: InputDecoration(labelText: 'Past Tense'),
            onChanged: (value) {
              widget.onChanged(widget.question..pastTense = value);
            },
          ),
          SizedBox(height: 20),
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

class Question {
  String presentTense;
  String pastTense;

  Question({required this.presentTense, required this.pastTense});
}

void saveQuestions(String collectionName, List<Question> questions, BuildContext context) async {
  // Prepare the structure for the "Questions" array field.
  List<Map<String, dynamic>> updatedQuestionsList = [];

  for (var question in questions) {
    // Each question is represented as a map with "Present Tense" and "Past Tense" fields.
    Map<String, dynamic> questionMap = {
      'Present Tense': question.presentTense,
      'Past Tense': question.pastTense,
    };
    updatedQuestionsList.add(questionMap);
  }

  try {
    final collectionReference = FirebaseFirestore.instance.collection(collectionName);
    final documentReference = collectionReference.doc('Questions');

    // Update the "Questions" array field with the new list.
    await documentReference.set({'Questions': updatedQuestionsList}, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Questions updated successfully!')),
    );
  } catch (error) {
    print("An error occurred: $error");
  }
}
