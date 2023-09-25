import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShortAnswerQuestions extends StatefulWidget {
  @override
  _ShortAnswerQuestionsState createState() => _ShortAnswerQuestionsState();
}

class _ShortAnswerQuestionsState extends State<ShortAnswerQuestions> {
  final TextEditingController answerController = TextEditingController();
  int currentQuestionIndex = 0;
  String? feedback;
  bool? isCorrect;

  final List<String> questions = [
    "Wanneer het Tom die tee vir sy ma gemaak?",
    "Wat is die hoofstad van Frankryk?",
    "In the following sentence:\n\nDie hond by die kat\n\n \"Hond\" is a:",
  ];

  final List<String> correctAnswers = [
    "Correct answer for question 1",
    "Paris",
    "Correct answer for question 3",
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Question ${currentQuestionIndex + 1}",
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  questions[currentQuestionIndex],
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontSize: 32,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Color(0xFF9ba0fc),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
                    ],
                  ),
                SizedBox(height: 140),
                Row(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

