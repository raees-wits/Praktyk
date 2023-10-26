import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/screens/comprehension_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FillInTheBlankWidget extends StatefulWidget {
  String sentenceEnglish = "";
  String sentenceID = "";
  String sentenceAfrikaans = "";
  Function() onDeleted;
  FillInTheBlankWidget(
      {required this.sentenceID,
      required this.sentenceEnglish,
      required this.sentenceAfrikaans,
      required this.onDeleted});
  @override
  _FillInTheBlankWidget createState() => _FillInTheBlankWidget();
}

class _FillInTheBlankWidget extends State<FillInTheBlankWidget> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var afrikaansTxt = TextEditingController();
  var englishTxt = TextEditingController();

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
                        title: Text('Delete Sentence'),
                        content: Text(
                            "Are you sure you want to delete this sentence?"),
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
                afrikaansTxt.text = widget.sentenceAfrikaans;
                englishTxt.text = widget.sentenceEnglish;
                final result = (await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Sentence'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: afrikaansTxt,
                                decoration: InputDecoration(
                                  labelText: 'Afrikaans',
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    afrikaansTxt.text = newValue;
                                  });
                                },
                              ),
                              TextField(
                                controller: englishTxt,
                                decoration: InputDecoration(
                                  labelText: 'English',
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    englishTxt.text = newValue;
                                  });
                                },
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  var result = await firestore
                                      .collection("sentences")
                                      .doc(widget.sentenceID)
                                      .update({
                                    "afrikaans": afrikaansTxt.text,
                                    "english": englishTxt.text
                                  });
                                  Navigator.of(context).pop(afrikaansTxt.text);
                                  afrikaansTxt.clear();
                                  englishTxt.clear();
                                },
                                child: Text('Confirm')),
                          ],
                        )));
              },
              child: Text(
                widget.sentenceAfrikaans,
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
