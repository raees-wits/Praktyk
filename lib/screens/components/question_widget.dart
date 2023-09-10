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
        trailing: TextButton(
          onPressed: () {
            // Handle the button press action here
            _showAnswerDialog(context);
          },
          child: Text("Answer this question"),
        ),
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (var answer in question.answers)
                AnswerWidget(answer),
            ],
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
