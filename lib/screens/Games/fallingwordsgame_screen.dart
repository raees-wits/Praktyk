import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FallingBubble extends StatefulWidget {
  final String word;
  final VoidCallback onTap;
  final List<double> activeBubblePositions;

  FallingBubble({
    required this.word,
    required this.onTap,
    required this.activeBubblePositions,
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
    //for bubbles to start above screen
    topPosition = -110.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    leftPosition = Random().nextDouble() * MediaQuery.of(context).size.width * 0.75;
    _startFalling();
  }




  _startFalling() async {
    // Calculaion of the number of possible segments based on bubble width plus padding
    int numberOfSegments = MediaQuery.of(context).size.width ~/ 50.0;
    double segmentWidth = MediaQuery.of(context).size.width / numberOfSegments;

    // Find an available segment by checking activeBubblePositions
    int segment;
    bool isPositionOccupied;
    do {
      segment = Random().nextInt(numberOfSegments);
      double tentativeLeftPosition = segment * segmentWidth;
      isPositionOccupied = widget.activeBubblePositions.any(
            (position) => (position - tentativeLeftPosition).abs() < 50.0,
      );
    } while (isPositionOccupied);

    // Set the left position only once when the bubble is created
    if (leftPosition == null) {
      // Center the bubble in the segment;
      leftPosition = segment * segmentWidth + (segmentWidth - 25.0) / 2;
    }

    final fallingDuration = Duration(seconds: 6);
    await Future.delayed(Duration(milliseconds: Random().nextInt(8000)));

    setState(() {
      topPosition = MediaQuery.of(context).size.height * 0.75;
    });

    widget.activeBubblePositions.add(leftPosition);

    await Future.delayed(fallingDuration);

    setState(() {
      // Reset the top position to start above the screen
      topPosition = -MediaQuery.of(context).size.height * 0.55;
      widget.activeBubblePositions.remove(leftPosition);

    });
    //falling loop
    _startFalling();


  }






  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: topPosition,
      left: leftPosition,
      // This should match the fallingDuration
      duration: Duration(seconds: 6),
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
        padding: EdgeInsets.all(16.0),
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
  // Placeholder for the word to be found
  String displayedWord = "Loading...";
  int score = 0;
  List<Map<String, dynamic>> wordPairs = [];
  late Timer gameTimer;
  int timeLeft = 25; // 25 seconds
  List<double> activeBubblePositions = [];
  List<String> bubbleWords = [];





  @override
  void initState() {
    super.initState();
    _startGameTimer();
    _fetchWordsFromFirestore().then((_) {
      _generateBubbleWords();
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
      // Store the current translation
      currentTranslation = randomPair["Answer"];
      setState(() {
        displayedWord = randomPair["Question"];
        // Include the correct translation in bubble words
        _prepareBubbleWordsWithTranslation(currentTranslation);
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
        // Randomly decide to show question or answer
        isQuestionDisplayed = Random().nextBool();
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
          _showResults();
        }
      });
    });
  }

  _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Time\'s Up!'),
          content: Text('Your Score: $score'),
          actions: <Widget>[
            TextButton(
              child: Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
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
    _startGameTimer();
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

    if (word == currentTranslation) {
      print("Correct answer tapped!");
      setState(() {
        score += 10;
        // Refresh the displayed word and bubble words
        _setInitialDisplayedWord();
      });
    } else {
      score -= 2;
      print("Tapped word does not match the correct translation.");
    }
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
              for (String word in bubbleWords)
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
                  // Adjust padding as needed
                  padding: EdgeInsets.only(top: 16.0, right: 16.0),
                  child: Column(
                    // Use min to fit the content
                    mainAxisSize: MainAxisSize.min,
                    // Align text to the right
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Time Left: $timeLeft",
                        style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
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