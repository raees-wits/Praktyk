import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FallingBubble extends StatefulWidget {
  final String word;
  final VoidCallback onTap;

  FallingBubble({required this.word, required this.onTap});

  @override
  _FallingBubbleState createState() => _FallingBubbleState();
}

class _FallingBubbleState extends State<FallingBubble> {
  late double topPosition;
  late double leftPosition;

  @override
  void initState() {
    super.initState();
    topPosition = -110.0; // Start above the screen
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    leftPosition = Random().nextDouble() * MediaQuery.of(context).size.width * 0.85; // Set a fixed left position
    _startFalling();
  }


  _startFalling() async {
    await Future.delayed(Duration(milliseconds: Random().nextInt(2000))); // Random delay before starting
    setState(() {
      topPosition = MediaQuery.of(context).size.height * 0.75; // End at the bottom of the white box
    });
    // Wait for the bubble to finish falling, then reset its position
    await Future.delayed(Duration(seconds: Random().nextInt(20) + 40)); // Further increased duration for slower fall
    setState(() {
      topPosition = -110.0; // Reset to top of the white box
      leftPosition = Random().nextDouble() * MediaQuery.of(context).size.width * 0.85; // Set a new left position within the white box
    });
    _startFalling(); // Start falling again
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: topPosition,
      left: leftPosition,
      duration: Duration(seconds: Random().nextInt(5) + 3),
      child: Bubble(
        word: widget.word,
        onTap: widget.onTap,
      ),
    );
  }
}


class Bubble extends StatelessWidget {
  final String word;
  final VoidCallback onTap;

  Bubble({required this.word, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0), // Increased padding
        constraints: BoxConstraints(
          minWidth: 100.0, // Minimum width
          minHeight: 100.0, // Minimum height
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            word,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class FallingWordsGameScreen extends StatefulWidget {
  @override
  _FallingWordsGameScreenState createState() => _FallingWordsGameScreenState();
}

class _FallingWordsGameScreenState extends State<FallingWordsGameScreen> {
  String displayedWord = "Loading..."; // Placeholder for the word to be found
  int score = 0;
  List<Map<String, dynamic>> wordPairs = [];
  late Timer gameTimer;
  int timeLeft = 25; // 25 seconds

  @override
  void initState() {
    super.initState();
    _fetchWordsFromFirestore();
    _startGameTimer();
  }

  _fetchWordsFromFirestore() async {
    try {
      final categoryDocs = await FirebaseFirestore.instance.collection('Match The Column').get();

      for (var categoryDoc in categoryDocs.docs) {
        if (categoryDoc.exists) {
          final data = categoryDoc.data() as Map<String, dynamic>;
          if (data.containsKey('Questions')) {
            final questionAnswerList = data['Questions'] as List<dynamic>;

            for (final entry in questionAnswerList) {
              if (entry is Map) {
                final castedEntry = entry as Map<String, dynamic>;
                if (castedEntry.containsKey('Question') && castedEntry.containsKey('Answer')) {
                  wordPairs.add(castedEntry);
                }
              }
            }
          }
        }
      }

      _updateDisplayedWord();
    } catch (e) {
      print("Error fetching words: $e");
    }
  }

  bool isQuestionDisplayed = true; // To track if a question or answer is displayed

  _updateDisplayedWord() {
    if (wordPairs.isNotEmpty) {
      final randomPair = wordPairs[Random().nextInt(wordPairs.length)];
      setState(() {
        isQuestionDisplayed = Random().nextBool();
        displayedWord = isQuestionDisplayed ? randomPair["Question"] : randomPair["Answer"];
      });
    }
  }



  _startGameTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
      });
      if (timeLeft <= 0) {
        timer.cancel();
        _showResults();
      }
    });
  }

  _showResults() {
    // Display results dialog
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  _bubbleTapped(String word) {
    if (word == displayedWord) {
      setState(() {
        score += 10;
      });
      _updateDisplayedWord();
    }
  }

  List _generateBubbleWords() {
    final displayedWordPairs = wordPairs..shuffle();
    final subsetWordPairs = displayedWordPairs.take(10).toList();

    // Filter the bubbles based on the displayed word
    return isQuestionDisplayed
        ? subsetWordPairs.map((e) => e["Answer"]).toList()
        : subsetWordPairs.map((e) => e["Question"]).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bubblesWords = _generateBubbleWords();

    return Scaffold(

      backgroundColor: Color(0xFFffaa5b),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
          height: MediaQuery.of(context).size.height * 0.75, // 75% of screen height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          child: Stack(
            children: [
              // Falling bubbles can be added here
              for (var word in bubblesWords)
                FallingBubble(
                  word: word,
                  onTap: () => _bubbleTapped(word),
                ),
              // Displayed word container
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    displayedWord,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),

              // Score box
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Score: $score",
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
