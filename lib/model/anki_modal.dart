import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


class AnkiModal extends StatefulWidget {
  final String englishWord;
  final String afrikaansWord;
  final String? audioClipUrl; // Change the type to accept null
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
  late AudioPlayer audioPlayer;
  TextEditingController textController = TextEditingController();
  Color backgroundColor = Colors.orange[100]!;
  Color buttonColor = Colors.green;
  Color textColor = Colors.white;

   @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  // Method to play audio
  void playAudio() async {
    if (widget.audioClipUrl != null) {
      await audioPlayer.play(widget.audioClipUrl!);
    }
  }
   @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Apply background color here
      backgroundColor: backgroundColor,
     
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
              playAudio(); // Play the audio clip
            },
            child: Icon(
              Icons.volume_up,
              size: 48.0,
            ),
            // Apply button style here
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              shape: CircleBorder(),
              padding: EdgeInsets.all(24.0),
            ),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: "Type your response here",
              // Set text color
              hintStyle: TextStyle(color: textColor),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              String userResponse = textController.text;
              widget.onConfirm(userResponse);
              Navigator.of(context).pop();
            },
            child: Text("Confirm"),
            // Apply button style here
            style: ElevatedButton.styleFrom(primary: buttonColor),
          ),
        ],
      ),
    );
  }
}