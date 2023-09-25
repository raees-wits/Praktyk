import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String text;
  final String answer;

  Question(this.id, this.text, this.answer);
}

class ComprehensionQuestionScreen extends StatefulWidget {
  String comprehensionID = 'Test';
  String comprehensionText = "Empty";
  String comprehensionTitle = "Empty";
  int questionNo = 0;

  ComprehensionQuestionScreen(
      {required this.comprehensionID,
      required this.comprehensionTitle,
      required this.comprehensionText,
      required this.questionNo});
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
  String answerText = "";
  Color answerColor = Colors.green;

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadQuestion() async {
    final querySnapshot = await firestore
        .collection('ComprehensionQuestions')
        .doc(widget.comprehensionID)
        .collection('Questions')
        .get();
    setState(() {
      questions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Question(doc.id, data['Text'], data['Answer']);
      }).toList();

      questionText = questions[widget.questionNo].text;
      questionAnswer = questions[widget.questionNo].answer;

      if (widget.questionNo == (questions.length - 1)) {
        nextText = "Done";
      }
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
                    Color(0x66ff6374),
                    Color(0x99ff6374),
                    Color(0xccff6374),
                    Color(0xFFff6374),
                  ])),
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                Text(widget.comprehensionTitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Question " + (widget.questionNo + 1).toString(),
                  style: TextStyle(
                      color: Colors.white,
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
                      color: Colors.white,
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
                          if (userAnswer ==
                              questions[widget.questionNo].answer) {
                            answerText = "Correct!";
                            answerColor = Colors.green;
                          } else if (userAnswer == "") {
                            answerText = "Please provide an answer";
                            answerColor = Colors.white;
                          } else {
                            answerText = "Incorrect! The correct answer is:\n" +
                                questions[widget.questionNo].answer;
                            answerColor = Colors.white;
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
                Text(
                  answerText,
                  style: TextStyle(
                      color: answerColor,
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
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Prev",
                                style: TextStyle(
                                    color: Color(0xFFff6374), fontSize: 15),
                              ),
                            )),
                        Text(
                          "Question " + (widget.questionNo + 1).toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
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
                              if (widget.questionNo == questions.length - 1) {
                                for (int i = 0; i < questions.length; i++) {
                                  Navigator.pop(context);
                                }
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ComprehensionQuestionScreen(
                                                comprehensionID:
                                                    widget.comprehensionID,
                                                comprehensionTitle:
                                                    widget.comprehensionTitle,
                                                comprehensionText:
                                                    widget.comprehensionText,
                                                questionNo:
                                                    widget.questionNo + 1)));
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
