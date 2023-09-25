import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async'; // Import dart:async for Timer

class ShortAnswerQuestions extends StatefulWidget {
  @override
  _ShortAnswerQuestionsState createState() => _ShortAnswerQuestionsState();
}

class _ShortAnswerQuestionsState extends State<ShortAnswerQuestions> {
  final TextEditingController answerController = TextEditingController();
  int currentQuestionIndex = 0;
  String? feedback;
  bool? isCorrect;
  double opacityLevel = 0.0; // Initial opacity level

  final List<String> questions = [
    "Wanneer het Tom die tee vir sy ma gemaak?",
    "Wat is die hoofstad van Frankryk?",
    "In the following sentence:\n\nDie hond by die kat\n\n \"Hond\" is a:",
  ];

  final List<String> correctAnswers = [
    "Yes",
    "Paris",
    "Dog",
  ];

  final Map<int, String> userAnswers = {};

  void submitAnswer() {
    setState(() {
      String userAnswer = answerController.text.trim();
      String correctAnswer = correctAnswers[currentQuestionIndex];

      userAnswers[currentQuestionIndex] = userAnswer;

      if (userAnswer == correctAnswer) {
        feedback = "Correct!";
        isCorrect = true;
      } else {
        feedback = "Incorrect! The correct answer is $correctAnswer";
        isCorrect = false;
      }
      opacityLevel = 1.0; // Set opacity level to 1 to make the icon visible
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        opacityLevel = 0.0; // Set opacity level to 0 to hide the icon after 2 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Set the arrow icon color
          onPressed: () => Navigator.of(context).pop(), // Pop the current screen
        ),
        title: Text(
          "Pick a choice",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x669ba0fc),
                Color(0x999ba0fc),
                Color(0xcc9ba0fc),
                Color(0xFF9ba0fc),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                Text(
                  "Question ${currentQuestionIndex + 1}",
                  style: TextStyle(
                    fontFamily: 'Cursive',
                    fontSize: 45,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Text(
                  questions[currentQuestionIndex],
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: answerController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Your answer here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Color(0xFF9ba0fc),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (feedback != null)
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        feedback!,
                        style: TextStyle(
                          color: isCorrect! ? Colors.green : Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      AnimatedOpacity(
                        opacity: opacityLevel,
                        duration: Duration(seconds: 1),
                        child: Icon(
                          isCorrect! ? Icons.check : Icons.close,
                          color: isCorrect! ? Colors.green : Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (currentQuestionIndex > 0) {
                    setState(() {
                      currentQuestionIndex--;
                    });
                  }
                },
                child: Text("Prev"),
              ),
              Text(
                "Question ${currentQuestionIndex + 1}",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (currentQuestionIndex < questions.length - 1) {
                    setState(() {
                      currentQuestionIndex++;
                    });
                  }
                },
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
