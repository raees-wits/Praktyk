import 'package:e_learning_app/screens/components/comprehension_widget.dart';
import 'package:e_learning_app/screens/components/teacher_fill_in_blanks_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sentence {
  String id;
  String english;
  String afrikaans;

  Sentence(this.id, this.english, this.afrikaans);
}

class TeacherFillInTheBlankScreen extends StatefulWidget {
  @override
  _TeacherFillInTheBlankScreen createState() => _TeacherFillInTheBlankScreen();
}

class _TeacherFillInTheBlankScreen extends State<TeacherFillInTheBlankScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Sentence> sentences = [];
  var englishTxt = TextEditingController();
  var afrikaansTxt = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComprehensions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDeleted(Sentence s) {
    firestore.collection('sentences').doc(s.id).delete();

    setState(() {
      sentences.remove(s);
    });

    Navigator.pop(context);
  }

  Future<void> loadComprehensions() async {
    final querySnapshot = await firestore.collection("sentences").get();
    setState(() {
      sentences = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Sentence(doc.id, data['english'], data['afrikaans']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fill in the Blank Sentences')),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () async {
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
                                    .add({
                                  "afrikaans": afrikaansTxt.text,
                                  "english": englishTxt.text
                                });

                                setState(() {
                                  sentences.add(Sentence(result.id,
                                      englishTxt.text, afrikaansTxt.text));
                                });

                                Navigator.of(context).pop(afrikaansTxt.text);
                                afrikaansTxt.clear();
                                englishTxt.clear();
                              },
                              child: Text('Confirm')),
                        ],
                      )));
            },
            child: Card(
              margin: EdgeInsets.all(10.0),
              child: Text(
                "Add New Sentence",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          for (var sentence in sentences)
            FillInTheBlankWidget(
              sentenceID: sentence.id,
              sentenceEnglish: sentence.english,
              sentenceAfrikaans: sentence.afrikaans,
              onDeleted: () {
                onDeleted(sentence);
              },
            )
        ],
      ),
    );
  }
}
