import 'package:e_learning_app/screens/Games/MemoryMatchSelectLevel.dart';
import 'package:e_learning_app/screens/Games/memoryMatchScreen.dart';
import 'package:flutter/material.dart';

import 'hangman_screen.dart';
import 'fallingwordsgame_screen.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({Key? key}) : super(key: key);

  // A method to create a button with a gradient background
  Widget buildGradientButton({required VoidCallback onPressed, required String text, required List<Color> colors}) {
    return Container(
      width: double.infinity, // makes the buttons take up all available space
      margin: EdgeInsets.all(8.0), // adds spacing around the buttons
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0), // if you want rounded corners
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Game'), // Changed app bar title
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adds padding on the left and right of the buttons
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildGradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FallingWordsGameScreen()),
                  );
                },
                text: 'Bubble Bananza', // change the button text
                colors: [Colors.blue, Colors.purple], // colors for the gradient
              ),
              buildGradientButton(
                onPressed: () {
                  // Navigate to the "Hangman" game screen when this is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HangmanGameScreen()), // replace with your actual HangmanGameScreen widget
                  );
                },
                text: 'Hangman',
                colors: [Colors.orange, Colors.red], // another set of colors for the gradient
              ),
              buildGradientButton(
                onPressed: () {
                  // Navigate to the "Hangman" game screen when this is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemoryMatchLevelSelect()), // replace with your actual HangmanGameScreen widget
                  );
                },
                text: 'Memory Match',
                colors: [Colors.yellow, Colors.orange], // another set of colors for the gradient
              ),
            ],
          ),
        ),
      ),
    );
  }
}