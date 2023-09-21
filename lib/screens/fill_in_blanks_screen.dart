import 'dart:math';

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

  @override
  void initState() {
    super.initState();
    _fetchQuestionsFromFirestore();
  }

  _fetchQuestionsFromFirestore() async {
    try {
      final sentences = await FirebaseFirestore.instance.collection('sentences')
          .get();

      // Collect all individual words from all sentences
      final allWords = sentences.docs
          .expand((doc) => (doc.data()['afrikaans'] as String).split(' '))
          .toSet() // Using a set to remove duplicates
          .toList();

      final validSentences = sentences.docs.where((QueryDocumentSnapshot doc) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data == null) return false; // Skip this document if data is null

        final words = (data['afrikaans'] as String?)?.split(' ');
        if (words == null) return false; // Skip this document if 'afrikaans' field is null or not a string

        return words.any((String word) => word.length >= 4);
      }).toList();



      validSentences.shuffle(); // Randomize the list

      for (var i = 0; i < 10 && i < validSentences.length; i++) {
        final sentence = validSentences[i].data()['afrikaans'] as String;
        final words = sentence.split(' ');
        final answer = words.firstWhere((word) => word.length >= 4);

        final otherOptions = allWords.where((word) =>
        word != answer && word.length >= answer.length).toList()
          ..shuffle();

        final options = [answer, ...otherOptions.sublist(0, min(3, otherOptions.length))];

        questions.add({
          'sentence': sentence.replaceAll(answer, '___'),
          'options': options..shuffle(),
          'answer': answer,
        });
      }

      setState(() {});
    }
    catch (e) {
      print("Error fetching sentences: $e");
      // Optionally, show an error dialog or some feedback to the user.
    }
  }





  @override
  Widget build(BuildContext context) {

    if (questions.isEmpty) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Show a loading spinner until questions are fetched
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Fill in the blanks'),
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
              child: Text(currentQuestion['sentence'],
                style: TextStyle(fontSize: 20.0),) // Increased text size),
            ),
            SizedBox(height: 25.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: currentQuestion['options'].map<Widget>((word) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedWord = word;
                        if (selectedWord == currentQuestion['answer']) {
                          _showFeedbackDialog('Correct!', Colors.green[300]!);
                        } else {
                          _showFeedbackDialog('Incorrect!', Colors.red[300]!);
                        }
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          word,
                          style: TextStyle(fontSize: 18.0), // Increased text size
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  if (currentQuestionIndex < questions.length - 1) {
                    setState(() {
                      currentQuestionIndex++;
                    });
                  } else {
                    // Example: Show a dialog when all questions are answered
                    _showFeedbackDialog('You have answered all questions!', Colors.indigoAccent[100]!);
                  }
                },
                child: Text('Next'),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
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
}
