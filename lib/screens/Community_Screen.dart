import 'package:flutter/material.dart';

import 'components/Question.dart';
import 'components/answer_widget.dart';
import 'components/question_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CommunityScreen extends StatelessWidget {
  final List<Question> questions = [
    Question(
      "How do I create a Flutter app?",
      [
        "You can create a Flutter app using the Flutter framework.",
        "Follow the Flutter documentation to get started.",
      ],
    ),
    Question(
      "What is Dart programming language?",
      [
        "Dart is a programming language used in Flutter development.",
        "It is an object-oriented, class-based language.",
      ],
    ),
    // Add more questions and answers here...
  ];

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
                  decoration: InputDecoration(
                    hintText: 'Write your question here...',
                  ),
                ),
                SizedBox(height: 16.0), // Add some spacing
                // Button to submit the question
                ElevatedButton(
                  onPressed: () {
                    // Handle question submission here
                    String enteredQuestion = ''; // Store the entered question text here
                    if (enteredQuestion.isNotEmpty) {
                      FirebaseFirestore.instance.collection('questions').add({
                        'text': enteredQuestion,
                        'timestamp': FieldValue.serverTimestamp(), // Optional, for timestamp
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
                SizedBox(height: 16.0), // Add some spacing
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
