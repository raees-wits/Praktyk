import 'package:e_learning_app/screens/TeacherScreens/teacher_comprehension_question_screen.dart';
import 'package:e_learning_app/screens/components/comprehension_widget.dart';
import 'package:e_learning_app/screens/components/teacher_comprehension_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comprehension {
  String id;
  String title;
  String text;

  Comprehension(this.id, this.title, this.text);
}

class TeacherComprehensionChoiceScreen extends StatefulWidget {
  @override
  _TeacherComprehensionChoiceScreen createState() =>
      _TeacherComprehensionChoiceScreen();
}

class _TeacherComprehensionChoiceScreen
    extends State<TeacherComprehensionChoiceScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Comprehension> comprehensions = [];

  @override
  void initState() {
    super.initState();
    loadComprehensions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadComprehensions() async {
    final querySnapshot =
        await firestore.collection("ComprehensionQuestions").get();
    setState(() {
      comprehensions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Comprehension(doc.id, data['Title'], data['Text']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comprehension')),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeacherComprehensionQuestionScreen(
                          comprehensionID: "",
                          comprehensionTitle: "",
                          comprehensionText: "",
                          questionNo: 0)));
            },
            child: Card(
              margin: EdgeInsets.all(10.0),
              child: Text(
                "Add New Comprehension",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          for (var comprehension in comprehensions)
            TeacherComprehensionWidget(
              comprehensionID: comprehension.id,
              comprehensionTitle: comprehension.title,
              comprehensionText: comprehension.text,
            )
        ],
      ),
    );
  }
}
