import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_learning_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FillInTheBlanksScreen extends StatefulWidget {
  @override
  _FillInTheBlanksScreenState createState() => _FillInTheBlanksScreenState();
}

class _FillInTheBlanksScreenState extends State<FillInTheBlanksScreen> {
  String selectedWord = '';
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [];
  int score = 0; // Added score variable
  int totalCorrectAnswers = 0;
  DateTime startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchQuestionsFromFirestore();
  }

  _fetchQuestionsFromFirestore() async {
    try {
      final sentences =
          await FirebaseFirestore.instance.collection('sentences').get();

      // Collect all individual words from all sentences
      final allWords = sentences.docs
          .expand((doc) => (doc.data()['afrikaans'] as String).split(' '))
          .toSet() // Using a set to remove duplicates
          .toList();

      final validSentences = sentences.docs.where((QueryDocumentSnapshot doc) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data == null) return false; // Skip this document if data is null

        final words = (data['afrikaans'] as String?)?.split(' ');
        if (words == null)
          return false; // Skip this document if 'afrikaans' field is null or not a string

        return words.any((String word) => word.length >= 4);
      }).toList();

      validSentences.shuffle(); // Randomize the list

      for (var i = 0; i < 10 && i < validSentences.length; i++) {
        final sentence = validSentences[i].data()['afrikaans'] as String;
        final englishTranslation = validSentences[i].data()['english']
            as String; // Fetching the English translation
        final words = sentence.split(' ');
        final answer = words.firstWhere((word) => word.length >= 4);

        final otherOptions = allWords
            .where((word) => word != answer && word.length >= answer.length)
            .toList()
          ..shuffle();

        final options = [
          answer,
          ...otherOptions.sublist(0, min(3, otherOptions.length))
        ];

        questions.add({
          'sentence': sentence.replaceAll(answer, '___'),
          'options': options..shuffle(),
          'answer': answer,
          'english': englishTranslation, // Storing the English translation
        });
      }

      setState(() {});
    } catch (e) {
      print("Error fetching sentences: $e");
    }
  }

  void _showHelpDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          backgroundColor: Colors.blue,
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Show a loading spinner until questions are fetched
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Fill in the blanks'),
        actions: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Score: $score",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[200]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 40.0),
            Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[800]!, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  currentQuestion['sentence'],
                  style: TextStyle(fontSize: 20.0),
                )),
            SizedBox(height: 25.0),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: currentQuestion['options'].map<Widget>((word) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (word == currentQuestion['answer']) {
                          score += 10;
                          totalCorrectAnswers++;
                          _showFeedbackDialog('Correct!', Colors.green[200]!);
                        } else {
                          score -= 2;
                          if (score < 0)
                            score = 0; // Ensure score doesn't go negative
                          _showFeedbackDialog('Incorrect!', Colors.red[300]!);
                        }
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          word,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Add the assistant figure here
            GestureDetector(
              onTap: () {
                if (currentQuestion.containsKey('english')) {
                  _showHelpDialog(currentQuestion['english']);
                }
              },
              child: Image.asset(
                'assets/images/talkingtoucan.png',
                width: 120,
                height: 120,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Need help, click me",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            Spacer(),

            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (currentQuestionIndex > 0) {
                        setState(() {
                          currentQuestionIndex--;
                        });
                      }
                    },
                    child: Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (currentQuestionIndex < questions.length - 1) {
                        setState(() {
                          currentQuestionIndex++;
                        });
                      } else {
                        _showResultsDialog();
                      }
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  void _showResultsDialog() {
    Duration timeTaken = DateTime.now().difference(startTime);
    double averageTimePerQuestion = timeTaken.inSeconds / questions.length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Final Results"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Score: $score"),
              Text("Time Taken: ${timeTaken.inSeconds} seconds"),
              Text(
                  "Average Time per Question: ${averageTimePerQuestion.toStringAsFixed(2)} seconds"),
              Text("Total Correct: $totalCorrectAnswers"),
            ],
          ),
          backgroundColor: Colors.purpleAccent[100],
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          backgroundColor: color,
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      score = 0;
      currentQuestionIndex = 0;
      totalCorrectAnswers = 0;
      startTime = DateTime.now();
      _fetchQuestionsFromFirestore();
    });
  }
}
