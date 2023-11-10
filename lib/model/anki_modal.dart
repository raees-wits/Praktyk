import 'package:flutter/material.dart';

class AnkiModal extends StatefulWidget {
  final String englishWord;
  final String afrikaansWord;
  final String audioClipUrl;
  final Function(String) onConfirm;

  AnkiModal({
    required this.englishWord,
    required this.afrikaansWord,
    required this.audioClipUrl,
    required this.onConfirm,
  });

  @override
  _AnkiModalState createState() => _AnkiModalState();
}

class _AnkiModalState extends State<AnkiModal> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Type what you hear'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.englishWord,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Play the audio clip from 'widget.audioClipUrl'
              // Implement your audio playback logic here.
            },
            child: Icon(
              Icons.volume_up,
              size: 48.0,
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(24.0),
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
              widget.onConfirm(userResponse); // Pass the user's response to the callback
              Navigator.of(context).pop(); // Close the modal
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
