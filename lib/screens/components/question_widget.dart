import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer_widget.dart';

class QuestionWidget extends StatelessWidget {
  final String questionId;
  final String questionText;

  QuestionWidget({required this.questionId, required this.questionText});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ExpansionTile(
        title: Text(
          questionText,
          style: TextStyle(fontSize: 16.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                _showAnswerDialog(context);
              },
              child: Text("Answer this question"),
            ),
            Icon(Icons.expand_more),
          ],
        ),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('questions')
                .doc(questionId)
                .collection('answers')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final answers = snapshot.data!.docs;
              List<Widget> answerWidgets = [];
              for (var answer in answers) {
                final answerText = answer['text'];
                answerWidgets.add(
                  AnswerWidget(
                    answer: answerText,
                    onUpvote: () {
                      // Handle upvote logic here
                    },
                    onDownvote: () {
                      // Handle downvote logic here
                    },
                  ),
                );
              }
              return Column(
                children: answerWidgets,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAnswerDialog(BuildContext context) {
    String answerText = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Answer this question"),
          content: TextField(
            onChanged: (text) {
              answerText = text;
            },
            decoration: InputDecoration(
              hintText: "Type your answer here...",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () async {
                if (answerText.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('questions')
                      .doc(questionId)
                      .collection('answers')
                      .add({
                    'text': answerText,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
