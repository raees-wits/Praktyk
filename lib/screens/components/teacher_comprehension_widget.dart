import 'package:e_learning_app/screens/TeacherScreens/teacher_comprehension_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TeacherComprehensionWidget extends StatefulWidget {
  String comprehensionTitle = "";
  String comprehensionID = "";
  String comprehensionText = "";
  Function() onDeleted;

  TeacherComprehensionWidget(
      {required this.comprehensionID,
      required this.comprehensionTitle,
      required this.comprehensionText,
      required this.onDeleted});

  @override
  _TeacherComprehensionWidget createState() => _TeacherComprehensionWidget();
}

class _TeacherComprehensionWidget extends State<TeacherComprehensionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        TextButton(
            onPressed: () async {
              final result = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Delete Comprehension'),
                        content: Text(
                            "Are you sure you want to delete this comprehension?"),
                        actions: [
                          TextButton(
                              onPressed: widget.onDeleted,
                              child: Text("Confirm"))
                        ],
                      ));
            },
            child: Text('X')),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TeacherComprehensionQuestionScreen(
                              comprehensionID: widget.comprehensionID,
                              comprehensionTitle: widget.comprehensionTitle,
                              comprehensionText: widget.comprehensionText,
                              questionNo: 0,
                            )));
              },
              child: Text(
                widget.comprehensionTitle,
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
