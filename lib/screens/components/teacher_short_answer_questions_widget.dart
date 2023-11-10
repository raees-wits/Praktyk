import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherShortAnswerWidget extends StatefulWidget {
  String id = "";
  String text = "";
  String answer = "";
  Function() onDeleted;

  TeacherShortAnswerWidget(
      {required this.id,
      required this.text,
      required this.answer,
      required this.onDeleted});

  @override
  _TeacherShortAnswerWidget createState() => _TeacherShortAnswerWidget();
}

class _TeacherShortAnswerWidget extends State<TeacherShortAnswerWidget> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var questionTxt = TextEditingController();
  var answerTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextButton(
              onPressed: () async {
                final result = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Delete Question'),
                          content: Text(
                              "Are you sure you want to delete this question?"),
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
                onTap: () async {
                  final result = (await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Question'),
                            content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: questionTxt,
                                    decoration: InputDecoration(
                                      labelText: 'Question',
                                    ),
                                  ),
                                  TextField(
                                    controller: answerTxt,
                                    decoration: InputDecoration(
                                      labelText: 'Answer',
                                    ),
                                  )
                                ]),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    var result = await firestore
                                        .collection("ShortAnswerQuestions")
                                        .doc(widget.id)
                                        .update({
                                      "Text": questionTxt.text,
                                      "Answer": answerTxt.text
                                    });
                                    Navigator.of(context).pop(questionTxt.text);
                                    questionTxt.clear();
                                    answerTxt.clear();
                                  },
                                  child: Text("Confirm"))
                            ],
                          )));
                },
                child: Text(
                  widget.text,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }
}
