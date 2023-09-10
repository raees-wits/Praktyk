import 'package:flutter/material.dart';

class AnswerWidget extends StatelessWidget {
  final String answer;

  AnswerWidget(this.answer);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        answer,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }
}