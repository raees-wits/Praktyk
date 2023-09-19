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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
        children: <Widget>[
          // Question Text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              questionText,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold, // Make it bold for emphasis
              ),
            ),
          ),
          // Asked by Text
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              "Asked by John Doe", // Replace with the actual name if available
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey, // Smaller text and in gray color
              ),
            ),
          ),
          // Answer Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAnswerDialog(context);
                  },
                  child: Text("Answer this question"),
                ),
              ],
            ),
          ),
          // Answers in ExpansionTile
          ExpansionTile(
            title: Text(
              "Answers",
              style: TextStyle(fontSize: 16.0),
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

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: answers.length,
                    itemBuilder: (context, index) {
                      final answerDoc = answers[index];
                      final answerText = answerDoc['text'];
                      final upvotes = answerDoc['upvotes'];
                      final downvotes = answerDoc['downvotes'];

                      return AnswerWidget(
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
                      );
                    },
                  );
                },
              ),
            ],
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