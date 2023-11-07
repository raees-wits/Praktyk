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
            onPressed: () => saveQuestions('Tenses', questions, context),
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
      final querySnapshot = await collectionReference.get();

      List<Question> loadedQuestions = [];
      for (var doc in querySnapshot.docs) { // Loop through the document snapshots
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Cast the document data to a Map
        // Create a new Question only if the expected fields exist
        if (data.containsKey('Present Tense') && data.containsKey('Past Tense')) {
          loadedQuestions.add(Question(
            id: doc.id, // Use the document's ID as the question's ID
            presentTense: data['Present Tense'],
            pastTense: data['Past Tense'],
          ));
        }
      }

      setState(() {
        questions = loadedQuestions;
      });
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
  String id; // Add an id field
  String presentTense;
  String pastTense;

  Question({this.id = '', required this.presentTense, required this.pastTense});

  // Add a method to convert a Question to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Present Tense': presentTense,
      'Past Tense': pastTense,
    };
  }
}

void saveQuestions(String collectionName, List<Question> questions, BuildContext context) async {
  final collectionReference = FirebaseFirestore.instance.collection('Tenses');
  final batch = FirebaseFirestore.instance.batch(); // Use a batch for multiple writes

  for (var question in questions) {
    if (question.id.isEmpty) {
      // If there is no id, we assume it's a new question, so we add it
      var newDocRef = collectionReference.doc();
      question.id = newDocRef.id; // Assign the new id to the question
      batch.set(newDocRef, question.toMap());
    } else {
      // If an id exists, we update the specific question
      var docRef = collectionReference.doc(question.id);
      batch.update(docRef, question.toMap());
    }
  }

  try {
    await batch.commit(); // Commit the batch
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Questions updated successfully!')),
    );
  } catch (error) {
    print("An error occurred: $error");
  }
}