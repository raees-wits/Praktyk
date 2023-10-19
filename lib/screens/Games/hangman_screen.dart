import 'package:flutter/material.dart';
import 'dart:math';

class HangmanGameScreen extends StatefulWidget {
  @override
  _HangmanGameScreenState createState() => _HangmanGameScreenState();
}

class _HangmanGameScreenState extends State<HangmanGameScreen> {
  // List of words to choose from. You can expand this list or fetch it from an external source.
  final List<String> words = ['FLUTTER', 'DART', 'WIDGET', 'STATE'];

  // Current word to guess
  late String currentWord;

  // Stores the letters of the current word as a set.
  late Set<String> currentWordLetters;

  // Stores the letters guessed by the user
  Set<String> guessedLetters = {};

  // Number of attempts remaining - starts at 5 for simplicity
  int attemptsRemaining = 5;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    currentWord = (words..shuffle(Random())).first; // Selects a random word
    currentWordLetters = Set<String>.from(currentWord.split(''));
    guessedLetters.clear();
    attemptsRemaining = 5;

    // Ensures the UI is updated
    setState(() {});
  }

  void _guessLetter(String letter) {
    if (currentWordLetters.contains(letter)) {
      guessedLetters.add(letter);
      if (guessedLetters.length == currentWordLetters.length) {
        // Win condition
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Congratulations!'),
                content: Text('You guessed the word correctly!'),
                actions: [
                  TextButton(
                    child: Text('New Game'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startNewGame();
                    },
                  ),
                ],
              );
            });
      }
    } else {
      if (--attemptsRemaining == 0) {
        // Lose condition
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Game Over'),
                content: Text('The correct word was "$currentWord".'),
                actions: [
                  TextButton(
                    child: Text('New Game'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startNewGame();
                    },
                  ),
                ],
              );
            });
      }
    }

    // Ensures the UI is updated
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
      ),
      body: Column(
        children: [
          Text(
            'Attempts remaining: $attemptsRemaining',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          SizedBox(height: 20),
          // This creates a display of underscores for letters not guessed yet, and letters for those guessed.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: currentWordLetters
                .map((letter) => guessedLetters.contains(letter)
                ? Text(letter)
                : Text('_'))
                .toList(),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                .split('')
                .map((letter) => ElevatedButton(
              onPressed: guessedLetters.contains(letter)
                  ? null // Disables the button if the letter has already been guessed
                  : () => _guessLetter(letter),
              child: Text(letter),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
