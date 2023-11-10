import 'package:e_learning_app/screens/components/teacher_short_answer_questions_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String id;
  String text;
  String answer;

  Question(this.id, this.text, this.answer);
}

class ManageShortAnswerScreen extends StatefulWidget {
  @override
  _ManageShortAnswerScreenState createState() =>
      _ManageShortAnswerScreenState();
}

class _ManageShortAnswerScreenState extends State<ManageShortAnswerScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Question> questions = [];
  var questionTxt = TextEditingController();
  var answerTxt = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onDeleted(Question s) {
    firestore.collection('ShortAnswerQuestions').doc(s.id).delete();

    setState(() {
      questions.remove(s);
    });

    Navigator.pop(context);
  }

  Future<void> loadQuestions() async {
    final querySnapshot =
        await firestore.collection("ShortAnswerQuestions").get();
    setState(() {
      questions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Question(doc.id, data['Text'], data['Answer']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Short Answer Questions'),
      ),
      body: Column(
        children: [
          GestureDetector(
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
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                var result = await firestore
                                    .collection("ShortAnswerQuestions")
                                    .add({
                                  "Text": questionTxt.text,
                                  "Answer": answerTxt.text
                                });

                                setState(() {
                                  questions.add(Question(result.id,
                                      questionTxt.text, answerTxt.text));
                                });

                                Navigator.of(context).pop(questionTxt.text);
                                questionTxt.clear();
                                answerTxt.clear();
                              },
                              child: Text('Confirm'))
                        ],
                      )));
            },
            child: Card(
              margin: EdgeInsets.all(10.0),
              child: Text(
                "Add New Question",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          for (var question in questions)
            TeacherShortAnswerWidget(
                id: question.id,
                text: question.text,
                answer: question.answer,
                onDeleted: () {
                  onDeleted(question);
                })
        ],
      ),
    );
  }
}
