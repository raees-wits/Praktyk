import 'package:flutter/material.dart';

class AnswerWidget extends StatefulWidget {
  final String answer;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  AnswerWidget({
    required this.answer,
    required this.onUpvote,
    required this.onDownvote, required upvotes, required downvotes,
  });

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: widget.onUpvote,
                ),
                IconButton(
                  icon: Icon(Icons.thumb_down),
                  onPressed: widget.onDownvote,
                ),
              ],
            ),
            SizedBox(width: 10), // Add spacing between voting and answer
            Expanded(
              child: Text(
                widget.answer,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
