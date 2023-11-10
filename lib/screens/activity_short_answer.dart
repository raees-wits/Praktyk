import 'package:e_learning_app/screens/leaderboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String text;
  final String answer;
  bool answered = false;
  bool correct = false;
  String userAnswer = "";
  String feedback = "";

  Question(this.text, this.answer);
}

class ShortAnswerQuestions extends StatefulWidget {
  @override
  _ShortAnswerQuestionsState createState() => _ShortAnswerQuestionsState();
}

class _ShortAnswerQuestionsState extends State<ShortAnswerQuestions> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController answerController = TextEditingController();
  int currentQuestionIndex = 0;
  String nextText = "Next";
  bool isLoading = true;

  List<Question> questions = [];

  @override
  void initState() {
    loadQuestions();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  void submitAnswer() {
    setState(() {
      String userAnswer = answerController.text.trim();
      String correctAnswer = questions[currentQuestionIndex].answer;

      questions[currentQuestionIndex].answered = true;
      questions[currentQuestionIndex].userAnswer = userAnswer;

      if (userAnswer == correctAnswer) {
        questions[currentQuestionIndex].feedback = "Correct!";
        questions[currentQuestionIndex].correct = true;
      } else {
        questions[currentQuestionIndex].feedback =
            "Incorrect! The correct answer is:\n\n $correctAnswer";
        questions[currentQuestionIndex].correct = false;
      }
    });
  }

  loadQuestions() async {
    final querySnapshot =
        await firestore.collection('ShortAnswerQuestions').get();
    setState(() {
      questions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Question(data['Text'], data['Answer']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF9ba0fc),
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Short Answer Questions",
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
                      Color(0xFF9ba0fc),
                      Color(0xcc9ba0fc),
                      Color(0x999ba0fc),
                      Color(0x669ba0fc),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
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
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            questions[currentQuestionIndex].text,
                            style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontSize: 32,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                        if (!questions[currentQuestionIndex].answered)
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
                        if (questions[currentQuestionIndex].answered)
                          Column(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                questions[currentQuestionIndex].feedback,
                                style: TextStyle(
                                  color: questions[currentQuestionIndex].correct
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 20),
                              Icon(
                                questions[currentQuestionIndex].correct
                                    ? Icons.check
                                    : Icons.close,
                                color: questions[currentQuestionIndex].correct
                                    ? Colors.green
                                    : Colors.red,
                                size: 30,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Color(0x999ba0fc),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (currentQuestionIndex > 0) {
                            setState(() {
                              nextText = "Next";
                              currentQuestionIndex--;
                            });
                            answerController.text =
                                questions[currentQuestionIndex].userAnswer;
                          } else {
                            Navigator.pop(context);
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
                              if (currentQuestionIndex ==
                                  questions.length - 1) {
                                nextText = "Done";
                              }
                            });
                            answerController.text =
                                questions[currentQuestionIndex].userAnswer;
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(nextText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
