import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String text;
  final String answer;

  Question(this.id, this.text, this.answer);
}

class TeacherComprehensionQuestionScreen extends StatefulWidget {
  String comprehensionID = 'Test';
  String comprehensionText = "Empty";
  String comprehensionTitle = "Empty";
  int questionNo = 0;

  TeacherComprehensionQuestionScreen(
      {required this.comprehensionID,
      required this.comprehensionTitle,
      required this.comprehensionText,
      required this.questionNo});
  @override
  _TeacherComprehensionQuestionScreenState createState() =>
      _TeacherComprehensionQuestionScreenState();
}

class _TeacherComprehensionQuestionScreenState
    extends State<TeacherComprehensionQuestionScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String questionText = "";
  String questionAnswer = "";
  String questionID = "";
  List<Question> questions = [];
  String nextText = "Next";
  String userAnswer = "";
  String answerText = "";
  Color answerColor = Colors.green;
  var titleTxt = TextEditingController();
  var textTxt = TextEditingController();
  var questionTxt = TextEditingController();
  var answerTxt = TextEditingController();
  bool isLast = false;

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

      if (widget.questionNo < questions.length) {
        questionText = questions[widget.questionNo].text;
        questionAnswer = questions[widget.questionNo].answer;
        questionID = questions[widget.questionNo].id;
      }
      titleTxt.text = widget.comprehensionTitle;
      textTxt.text = widget.comprehensionText;
      questionTxt.text = questionText;
      answerTxt.text = questionAnswer;

      if (widget.questionNo >= (questions.length - 1)) {
        nextText = "Done";
        isLast = true;
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
                    Color(0xFFfdfd96),
                    Color(0xFFfcfcc0),
                    Color(0xFFfafad2),
                    Color(0xFFfcfcfa),
                  ])),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        controller: titleTxt,
                        maxLines: null,
                        onChanged: (String newValue) {
                          setState(() {
                            titleTxt.text = newValue;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            labelText: 'The Comprehension Title',
                            hintStyle: TextStyle(color: Colors.black38)),
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Question " + (widget.questionNo + 1).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: textTxt,
                        onChanged: (String newValue) {
                          setState(() {
                            textTxt.text = newValue;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            labelText: 'The Comprehension Text',
                            hintStyle: TextStyle(color: Colors.black38)),
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: questionTxt,
                        onChanged: (String newValue) {
                          setState(() {
                            questionTxt.text = newValue;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            labelText: 'The Question',
                            hintStyle: TextStyle(color: Colors.black38)),
                        style: TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: answerTxt,
                        onChanged: (String newValue) {
                          setState(() {
                            answerTxt.text = newValue;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 15),
                            labelText: 'The answer to the question',
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
                      padding: EdgeInsets.symmetric(horizontal: 15),
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
                          onTap: () async {
                            setState(() {
                              widget.comprehensionTitle = titleTxt.text;
                              widget.comprehensionText = textTxt.text;
                            });

                            if (widget.comprehensionID == "") {
                              var result = await FirebaseFirestore.instance
                                  .collection('ComprehensionQuestions')
                                  .add({
                                'Text': textTxt.text,
                                'Title': titleTxt.text
                              });

                              setState(() {
                                widget.comprehensionID = result.id;
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('ComprehensionQuestions')
                                  .doc(widget.comprehensionID)
                                  .update({
                                'Text': textTxt.text,
                                'Title': titleTxt.text
                              });
                            }

                            if (questionID == "") {
                              isLast = true;
                              nextText = "Done";
                              await FirebaseFirestore.instance
                                  .collection('ComprehensionQuestions')
                                  .doc(widget.comprehensionID)
                                  .collection("Questions")
                                  .add({
                                'Answer': answerTxt.text,
                                'Text': questionTxt.text
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('ComprehensionQuestions')
                                  .doc(widget.comprehensionID)
                                  .collection("Questions")
                                  .doc(questionID)
                                  .update({
                                'Answer': answerTxt.text,
                                'Text': questionTxt.text
                              });
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Color(0xFFff6374), fontSize: 15),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (isLast)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
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
                                isLast = false;
                                nextText = "Next";
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherComprehensionQuestionScreen(
                                              comprehensionID:
                                                  widget.comprehensionID,
                                              comprehensionTitle:
                                                  widget.comprehensionTitle,
                                              comprehensionText:
                                                  widget.comprehensionText,
                                              questionNo: questions.length)));
                            },
                            child: Text(
                              "Add question",
                              style: TextStyle(
                                  color: Color(0xFFff6374), fontSize: 15),
                            )),
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
                                  color: Colors.black,
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
                                  if (isLast) {
                                    for (int i = 0; i < questions.length; i++) {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeacherComprehensionQuestionScreen(
                                                    comprehensionID:
                                                        widget.comprehensionID,
                                                    comprehensionTitle: widget
                                                        .comprehensionTitle,
                                                    comprehensionText: widget
                                                        .comprehensionText,
                                                    questionNo:
                                                        widget.questionNo +
                                                            1)));
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
