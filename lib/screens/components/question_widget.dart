import 'package:flutter/material.dart';

import 'Question.dart';
import 'answer_widget.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;

  QuestionWidget(this.question);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: ExpansionTile(
        title: Text(
          question.question,
          style: TextStyle(fontSize: 16.0),
        ),
        trailing: Row( // Wrap in a Row widget
          mainAxisSize: MainAxisSize.min, // Ensure the Row takes minimum space
          children: [
            TextButton(
              onPressed: () {
                // Handle the button press action here
                _showAnswerDialog(context);
              },
              child: Text("Answer this question"),
            ),
            Icon(Icons.expand_more), // Add the dropdown icon
          ],
        ),
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: question.answers.length,
            itemBuilder: (context, index) {
              final answer = question.answers[index];
              return AnswerWidget(
                answer: answer, // Pass the answer to AnswerWidget
                onUpvote: () {
                  // Handle upvote logic here
                  // You can update the vote count for the answer
                },
                onDownvote: () {
                  // Handle downvote logic here
                  // You can update the vote count for the answer
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to show a dialog for answering the question
  void _showAnswerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Answer this question"),
          content: TextField(
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
              onPressed: () {
                // Handle the submitted answer here
                // You can save it to a database or update the UI as needed
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
