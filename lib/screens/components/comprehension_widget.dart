import 'package:e_learning_app/screens/comprehension_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ComprehensionWidget extends StatelessWidget {
  String comprehensionTitle = "";
  String comprehensionID = "";
  String comprehensionText = "";

  ComprehensionWidget(
      {required this.comprehensionID,
      required this.comprehensionTitle,
      required this.comprehensionText});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComprehensionQuestionScreen(
                                  comprehensionID: comprehensionID,
                                  comprehensionTitle: comprehensionTitle,
                                  comprehensionText: comprehensionText,
                                  questionNo: 0,
                                )));
                  },
                  child: Text(
                    comprehensionTitle,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
            )
          ]),
    );
  }
}
