import 'package:flutter/material.dart';

class FillInTheBlanksScreen extends StatefulWidget {
  @override
  _FillInTheBlanksScreenState createState() => _FillInTheBlanksScreenState();
}

class _FillInTheBlanksScreenState extends State<FillInTheBlanksScreen> {
  String selectedWord = '';
  int currentQuestionIndex = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'sentence': 'I ate an ___ for breakfast.',
      'options': ['apple', 'banana', 'cherry', 'date'],
      'answer': 'apple',
    },
    {
      'sentence': 'The ___ is blue.',
      'options': ['sky', 'grass', 'apple', 'car'],
      'answer': 'sky',
    },
    // Add more questions as needed
  ];

  @override
  Widget build(BuildContext context) {
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
                    // Handle end of questions, maybe navigate to a results page or show a message
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
