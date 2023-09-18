import 'package:flutter/material.dart';

class AnkiModal extends StatelessWidget {
  final String word;
  final VoidCallback onConfirm;

  AnkiModal({
    required this.word,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    return AlertDialog(
      title: Text('Type what you hear'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            word,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Type your response here",
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              String userResponse = textController.text;
              onConfirm(); // Pass the user's response to the callback
              Navigator.of(context).pop(); // Close the modal
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
