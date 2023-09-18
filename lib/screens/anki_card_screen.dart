import 'package:flutter/material.dart';

class AnkiCardScreen extends StatelessWidget {
  final String word; // Pass the word you want to display on the card

  AnkiCardScreen({required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anki Card"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Type what you hear", // Display "Type what you hear" message
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Pretend to play an audio clip when the button is pressed
                // You can add actual audio playback logic here
              },
              child: Icon(
                Icons.volume_up, // Use an icon for the audio button
                size: 48.0, // Set the icon size
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(), // Make the button circular
                padding: EdgeInsets.all(24.0), // Add padding to the button
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: "Your Response", // Add a label to the text field
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Add your logic for confirming the response here
              },
              child: Text("Confirm"),
              style: ElevatedButton.styleFrom(
                primary:
                    Colors.green, // Set the button background color to green
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
