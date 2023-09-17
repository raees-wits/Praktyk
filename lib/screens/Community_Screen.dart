import 'package:flutter/material.dart';
import 'components/Question.dart';
import 'components/question_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController questionController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final querySnapshot = await firestore.collection('questions').get();
    setState(() {
      questions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Question(
            doc.id, // Use the document ID as the unique ID
            data['text'],
            [] // You can add answers here if needed
        );
      }).toList();
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Page'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Text box for entering a question
                TextFormField(
                  controller: questionController,
                  decoration: InputDecoration(
                    hintText: 'Write your question here...',
                  ),
                ),
                SizedBox(height: 16.0),
                // Button to submit the question
                ElevatedButton(
                  onPressed: () async {
                    // Handle question submission here
                    String enteredQuestion = questionController.text;
                    if (enteredQuestion.isNotEmpty) {
                      await firestore.collection('questions').add({
                        'text': enteredQuestion,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      // Clear the text field after submitting
                      questionController.clear();
                      // Reload questions to reflect the newly added one
                      loadQuestions();
                    }
                  },
                  child: Text('Submit'),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
          for (var question in questions)
            QuestionWidget(question),
        ],
      ),
    );
  }
}
