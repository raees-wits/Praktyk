import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FallingBubble extends StatefulWidget {
  final String word;
  final VoidCallback onTap;
  final List<double> activeBubblePositions; // Add this line

  FallingBubble({
    required this.word,
    required this.onTap,
    required this.activeBubblePositions, // Add this line
  });

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
    leftPosition = Random().nextDouble() * MediaQuery.of(context).size.width * 0.75; // Set a fixed left position
    _startFalling();
  }




  _startFalling() async {
    // Calculate the number of possible segments based on bubble width plus padding
    int numberOfSegments = MediaQuery.of(context).size.width ~/ 80.0;
    double segmentWidth = MediaQuery.of(context).size.width / numberOfSegments;

    // Find an available segment by checking activeBubblePositions
    int segment;
    bool isPositionOccupied;
    do {
      segment = Random().nextInt(numberOfSegments);
      double tentativeLeftPosition = segment * segmentWidth;
      isPositionOccupied = widget.activeBubblePositions.any(
            (position) => (position - tentativeLeftPosition).abs() < 80.0,
      );
    } while (isPositionOccupied);

    // Set the left position only once when the bubble is created
    if (leftPosition == null) {
      leftPosition = segment * segmentWidth + (segmentWidth - 80.0) / 2; // Center the bubble in the segment;
    }

    final fallingDuration = Duration(seconds: 10); // Standardized falling duration
    await Future.delayed(Duration(milliseconds: Random().nextInt(7000)));

    setState(() {
      topPosition = MediaQuery.of(context).size.height * 0.75;
    });

    widget.activeBubblePositions.add(leftPosition);

    await Future.delayed(fallingDuration);

    setState(() {
      topPosition = -610.0;
      widget.activeBubblePositions.remove(leftPosition);
    });

    _startFalling();
  }






  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: topPosition,
      left: leftPosition,
      duration: Duration(seconds: 10), // This should match the fallingDuration
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
            colors: [Colors.blue, Colors.purpleAccent],
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
  List<double> activeBubblePositions = []; // Add this line
  List<String> bubbleWords = []; // Add this line at the top of your class





  @override
  void initState() {
    super.initState();
    _startGameTimer();
    _fetchWordsFromFirestore().then((_) {
      _generateBubbleWords(); // Call this only after wordPairs is populated
    });
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

      // Once words are fetched, set the initial displayed word and its translation
      _setInitialDisplayedWord();
    } catch (e) {
      print("Error fetching words: $e");
    }
  }


  //stopped here


  String currentTranslation = "";

  void _setInitialDisplayedWord() {
    if (wordPairs.isNotEmpty) {
      final randomPair = wordPairs[Random().nextInt(wordPairs.length)];
      currentTranslation = randomPair["Answer"]; // Store the correct translation
      setState(() {
        displayedWord = randomPair["Question"];
        _prepareBubbleWordsWithTranslation(currentTranslation); // Include the correct translation in bubble words
      });
    }
  }

  void _prepareBubbleWordsWithTranslation(String translation) {
    // Create a list of words for the bubbles, excluding the current displayed word and its translation
    List<String> newBubbleWords = wordPairs
        .where((pair) => pair["Question"] != displayedWord && pair["Answer"] != displayedWord)
        .map((pair) => isQuestionDisplayed ? pair["Answer"] : pair["Question"])
        .toList() // Convert to List<String>
        .cast<String>(); // Explicitly cast the elements to type String

    // Randomly shuffle the list
    newBubbleWords.shuffle();

    // Ensure the list contains the translation and has exactly 10 elements
    newBubbleWords = newBubbleWords.take(9).toList()..add(translation);
    newBubbleWords.shuffle();

    setState(() {
      bubbleWords = newBubbleWords;
    });
  }



  bool isQuestionDisplayed = true; // To track if a question or answer is displayed

  void _updateDisplayedWord() {
    if (wordPairs.isNotEmpty) {
      // Randomly select a word pair
      final randomPair = wordPairs[Random().nextInt(wordPairs.length)];
      setState(() {
        isQuestionDisplayed = Random().nextBool(); // Randomly decide to show question or answer
        displayedWord = isQuestionDisplayed ? randomPair["Question"] : randomPair["Answer"];
      });

    }
  }




  _startGameTimer() {
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          _showResults(); // Call the method to show results when the time is up
        }
      });
    });
  }

  _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orangeAccent, // Adjust the color as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Time\'s Up!'),
          content: Text('Your Score: $score'),
          actions: <Widget>[
            TextButton(
              child: Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                _restartGame(); // Call the method to restart the game
              },
            ),
          ],
        );
      },
    );
  }

  _restartGame() {
    setState(() {
      score = 0;
      timeLeft = 25;
      // Reset any other game state as necessary
      // e.g., clear bubbles, reset positions, fetch new words, etc.
      _fetchWordsFromFirestore().then((_) {
        _generateBubbleWords(); // Regenerate bubble words after fetching
      });
    });
    _startGameTimer(); // Restart the game timer
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }

  _bubbleTapped(String word) {
    print("Bubble tapped with word: $word");
    print("Displayed word: $displayedWord");
    print("Correct translation: $currentTranslation");

    if (word == currentTranslation) { // Check against the correct translation
      print("Correct answer tapped!");
      setState(() {
        score += 10;
        _setInitialDisplayedWord(); // Refresh the displayed word and bubble words
      });
    } else {
      score -= 2;
      print("Tapped word does not match the correct translation.");
    }
  }



  void _clearAndGenerateNewBubbles() {
    setState(() {
      bubbleWords.clear(); // Clear the current words
      _updateDisplayedWord(); // Generate new word and bubbles
    });
  }


  List _generateBubbleWords() {
    return List.generate(10, (_) {
      final randomPair = wordPairs[Random().nextInt(wordPairs.length)];
      final word = isQuestionDisplayed ? randomPair["Answer"] : randomPair["Question"];

      return FallingBubble(
        word: word,
        onTap: () => _bubbleTapped(word),
        activeBubblePositions: activeBubblePositions, // Pass the list here
      );
    });
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
              for (String word in bubbleWords) // Use bubbleWords here
                FallingBubble(
                  word: word,
                  onTap: () => _bubbleTapped(word),
                  activeBubblePositions: activeBubblePositions,
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
                  padding: EdgeInsets.only(top: 16.0, right: 16.0), // Adjust padding as needed
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Use min to fit the content
                    crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
                    children: <Widget>[
                      Text(
                        "Time Left: $timeLeft",
                        style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0), // Space between the timer and the score
                      Text(
                        "Score: $score",
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
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