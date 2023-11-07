import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherFutureTenseScreen extends StatefulWidget {
  const TeacherFutureTenseScreen({Key? key}) : super(key: key);

  @override
  _TeacherFutureTenseScreenState createState() => _TeacherFutureTenseScreenState();
}

class _TeacherFutureTenseScreenState extends State<TeacherFutureTenseScreen> {
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions(); // Load questions when the screen is initialized
  }

  void addNewQuestion() {
    setState(() {
      // Create a new question with default values for the future tense
      var newQuestion = Question(
        presentTense: '', // Start with an empty string for present tense
        futureTense: '', // Start with an empty string for future tense
      );

      // Add the new question to the list of questions
      questions.add(newQuestion);
    });
  }

  void deleteQuestion(String questionId, int index) async {
    if (questionId.isEmpty) {
      // If the question doesn't have an ID, it hasn't been saved to Firestore yet
      // so you can remove it directly from the local list.
      setState(() {
        questions.removeAt(index);
      });
    } else {
      // If it has an ID, delete the document from Firestore.
      final collectionReference = FirebaseFirestore.instance.collection('Tenses');
      await collectionReference.doc(questionId).delete().then((_) {
        setState(() {
          questions.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question deleted successfully!')),
        );
      }).catchError((error) {
        print("Error deleting question: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete question')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Future Tense Questions'), // Updated title for future tense
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
                  index: index, // Pass the current index
                  id: questions[index].id, // Pass the question's ID
                  onChanged: (updatedQuestion) {
                    setState(() {
                      questions[index] = updatedQuestion;
                    });
                  },
                  onRemove: () {
                    deleteQuestion(questions[index].id, index); // Call deleteQuestion with ID and index
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
      final collectionReference = FirebaseFirestore.instance.collection(
          'Tenses');
      final querySnapshot = await collectionReference.get();

      List<Question> loadedQuestions = [];
      for (var doc in querySnapshot
          .docs) { // Loop through the document snapshots
        Map<String, dynamic> data = doc.data() as Map<String,
            dynamic>; // Cast the document data to a Map
        // Check for 'Present Tense' and create a new Question even if 'Future Tense' is missing.
        String presentTense = data['Present Tense'] ??
            'No Present Tense added'; // Use a fallback text if 'Present Tense' is null
        String futureTense = data['Future Tense'] ??
            'Add Future Tense Here'; // Provide default text for 'Future Tense'

        loadedQuestions.add(Question(
          id: doc.id, // Use the document's ID as the question's ID
          presentTense: presentTense,
          futureTense: futureTense,
        ));
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
  final int index;
  final String id;

  QuestionEditor({
    required this.question,
    required this.onChanged,
    required this.onRemove,
    required this.index,
    required this.id,
  });

  @override
  _QuestionEditorState createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  late TextEditingController presentTenseController;
  late TextEditingController futureTenseController;

  @override
  void initState() {
    super.initState();
    presentTenseController = TextEditingController(text: widget.question.presentTense);
    futureTenseController = TextEditingController(text: widget.question.futureTense);
  }

  @override
  void dispose() {
    presentTenseController.dispose();
    futureTenseController.dispose();
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
            decoration: InputDecoration(
              labelText: 'Present Tense',
              hintText: 'Enter present tense here', // guide text as a hint for present tense
            ),
            onChanged: (value) {
              widget.onChanged(widget.question..presentTense = value);
            },
          ),
          TextField(
            controller: futureTenseController,
            decoration: InputDecoration(
              labelText: 'Future Tense',
              hintText: 'Enter future tense here', // guide text as a hint for future tense
            ),
            onChanged: (value) {
              widget.onChanged(widget.question..futureTense = value);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => widget.onRemove(),
            child: Text('Remove Question'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
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
  String futureTense; // Changed to future tense

  Question({this.id = '', required this.presentTense, required this.futureTense});

  // Add a method to convert a Question to Map for future tense
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Present Tense': presentTense,
      'Future Tense': futureTense, // Changed to future tense
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
