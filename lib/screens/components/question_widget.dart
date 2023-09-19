import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer_widget.dart';

class QuestionWidget extends StatelessWidget {
  final String questionId;
  final String questionText;

  Future<void> _upvoteAnswer(String questionId, String answerId) async {
    final answerRef = FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .doc(answerId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final answerDoc = await transaction.get(answerRef);
      final currentUpvotes = answerDoc['upvotes'] ?? 0;
      transaction.update(answerRef, {'upvotes': currentUpvotes + 1});
    });
  }

  Future<void> _downvoteAnswer(String questionId, String answerId) async {
    final answerRef = FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .doc(answerId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final answerDoc = await transaction.get(answerRef);
      final currentDownvotes = answerDoc['downvotes'] ?? 0;
      transaction.update(answerRef, {'downvotes': currentDownvotes + 1});
    });
  }


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
              for (var answerDoc in answers) {
                final answerText = answerDoc['text'];
                final upvotes = answerDoc['upvotes'];
                final downvotes = answerDoc['downvotes'];

                answerWidgets.add(
                  AnswerWidget(
                    answer: answerText,
                    upvotes: upvotes,
                    downvotes: downvotes,
                    onUpvote: () async {
                      // Handle upvote logic here
                      await _upvoteAnswer(questionId, answerDoc.id);
                    },
                    onDownvote: () async {
                      // Handle downvote logic here
                      await _downvoteAnswer(questionId, answerDoc.id);
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
                    'upvotes': 0, // Initial upvotes count
                    'downvotes': 0, // Initial downvotes count
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