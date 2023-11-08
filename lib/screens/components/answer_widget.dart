import 'package:flutter/material.dart';

class AnswerWidget extends StatefulWidget {
  final String? answer;
  final int upvotes;
  final int downvotes;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final String? posterName;
  final String userVote;

  AnswerWidget({
    required this.answer,
    required this.upvotes,
    required this.downvotes,
    required this.onUpvote,
    required this.onDownvote,
    this.posterName,
    required this.userVote,
  });

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  int totalVotes() {
    return widget.upvotes - widget.downvotes;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.answer != null)
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Posted by ${widget.posterName ?? 'Anonymous'}',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ),
          if (widget.answer == null)
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                'Be the first to answer!',
                style: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          if (widget.answer != null)
            Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text(
                widget.answer!,
                style: TextStyle(fontSize:18.0),
              ),
            ),
          SizedBox(height: 2), // Add spacing between answer text and vote buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(Icons.thumb_up),
                  onPressed: widget.onUpvote,
                  color: widget.userVote == 'upvote' ? Colors.blue : Colors.black, // Change color based on the user's vote

                ),
              ),
              Text(
                '${totalVotes()}',
                style: TextStyle(fontSize: 14.0),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(Icons.thumb_down),
                  onPressed: widget.onDownvote,
                  color: widget.userVote == 'downvote' ? Colors.blue : Colors.black, // Change color based on the user's vote

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
