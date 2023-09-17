import 'package:flutter/material.dart';

class AnswerWidget extends StatelessWidget {
  final String answer;
  final int upvotes;
  final int downvotes;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  AnswerWidget({
    required this.answer,
    required this.upvotes,
    required this.downvotes,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate cumulative vote count
    int totalVotes = upvotes - downvotes;

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: onUpvote,
                ),
                Text('$totalVotes'), // Display total vote count
                IconButton(
                  icon: Icon(Icons.thumb_down),
                  onPressed: onDownvote,
                ),
              ],
            ),
            SizedBox(width: 10.0), // Add spacing between buttons and text
            Expanded(
              child: Text(
                answer,
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
