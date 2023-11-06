import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String text;
  final String answer;
  final int questionNo;
  bool answered = false;
  String userAnswer = "";
  String answerFeedback = "";
  Color answerColor = Colors.green;

  Question(this.id, this.text, this.answer, this.questionNo);
}

class ComprehensionQuestionScreen extends StatefulWidget {
  String comprehensionID = 'Test';
  String comprehensionText = "Empty";
  String comprehensionTitle = "Empty";

  ComprehensionQuestionScreen(
      {required this.comprehensionID,
      required this.comprehensionTitle,
      required this.comprehensionText});
  @override
  _ComprehensionQuestionScreenState createState() =>
      _ComprehensionQuestionScreenState();
}

class _ComprehensionQuestionScreenState
    extends State<ComprehensionQuestionScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String questionText = "Empty";
  String questionAnswer = "";
  List<Question> questions = [];
  String nextText = "Next";
  String userAnswer = "";
  int questionNo = 0;
  var answerTxtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setUpQuestion() {
    setState(() {
      questionText = questions[questionNo].text;
      questionAnswer = questions[questionNo].answer;
      if (questionNo == (questions.length - 1)) {
        nextText = "Done";
      }
      answerTxtController.text = "";
    });
  }

  loadQuestion() async {
    final querySnapshot = await firestore
        .collection('ComprehensionQuestions')
        .doc(widget.comprehensionID)
        .collection('Questions')
        .get();
    setState(() {
      questions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Question(
            doc.id, data['Text'], data['Answer'], data['QuestionNo']);
      }).toList();

      questions.sort((a, b) => a.questionNo.compareTo(b.questionNo));
      setUpQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color(0xFFfdfd96),
                    Color(0xFFfcfcc0),
                    Color(0xFFfafad2),
                    Color(0xFFfcfcfa),
                  ])),
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                Text(widget.comprehensionTitle,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Question " + (questionNo + 1).toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    widget.comprehensionText,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  questionText,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2))
                      ]),
                  child: TextField(
                    controller: answerTxtController,
                    onChanged: (String newValue) {
                      setState(() {
                        userAnswer = newValue;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: 'Your answer here',
                        hintStyle: TextStyle(color: Colors.black38)),
                    style: TextStyle(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                if (!questions[questionNo].answered)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2))
                        ]),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (userAnswer.toUpperCase() ==
                                questions[questionNo].answer.toUpperCase()) {
                              questions[questionNo].answerFeedback = "Correct!";
                              questions[questionNo].answerColor = Colors.green;
                              questions[questionNo].answered = true;
                              questions[questionNo].userAnswer = userAnswer;
                            } else if (userAnswer == "") {
                              questions[questionNo].answerFeedback =
                                  "Please provide an answer";
                              questions[questionNo].answerColor = Colors.red;
                            } else {
                              questions[questionNo].answerFeedback =
                                  "Incorrect! The correct answer is:\n" +
                                      questions[questionNo].answer;
                              questions[questionNo].answerColor = Colors.red;
                              questions[questionNo].answered = true;
                              questions[questionNo].userAnswer = userAnswer;
                            }
                          });
                        },
                        child: Text(
                          "Submit",
                          style:
                              TextStyle(color: Color(0xFFff6374), fontSize: 15),
                        )),
                  ),
                SizedBox(
                  height: 15,
                ),
                if (questions[questionNo].answered)
                  Text(
                    questions[questionNo].answerFeedback,
                    style: TextStyle(
                        color: questions[questionNo].answerColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                Flexible(
                    child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2))
                                ]),
                            child: GestureDetector(
                              onTap: () {
                                if (questionNo == 0) {
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    questionNo--;
                                  });
                                  setUpQuestion();
                                  answerTxtController.text =
                                      questions[questionNo].userAnswer;
                                }
                              },
                              child: Text(
                                "Prev",
                                style: TextStyle(
                                    color: Color(0xFFff6374), fontSize: 15),
                              ),
                            )),
                        Text(
                          "Question " + (questionNo + 1).toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        if (questions[questionNo].answered)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2))
                                ]),
                            child: GestureDetector(
                              onTap: () {
                                if (questionNo == questions.length - 1) {
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    questionNo++;
                                  });
                                  answerTxtController.text =
                                      questions[questionNo].userAnswer;
                                  setUpQuestion();
                                }
                              },
                              child: Text(
                                nextText,
                                style: TextStyle(
                                    color: Color(0xFFff6374), fontSize: 15),
                              ),
                            ),
                          ),
                      ]),
                )),
                SizedBox(
                  height: 20,
                )
              ]),
            )
          ],
        ),
      ),
    ));
  }
}
