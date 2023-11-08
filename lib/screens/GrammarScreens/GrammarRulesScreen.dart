import 'package:e_learning_app/screens/GrammarScreens/FutureTenseScreen.dart';
import 'package:e_learning_app/screens/GrammarScreens/IndirectSpeechScreen.dart';
import 'package:e_learning_app/screens/GrammarScreens/NegativeFormScreen.dart';
import 'package:e_learning_app/screens/TeacherScreens/teacherFutureTenseScreen.dart';
import 'package:e_learning_app/screens/TeacherScreens/teacherSpeechScreen.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/constants.dart';

import '../TeacherScreens/teacherNegativeFormScreen.dart';
import '../TeacherScreens/teacherPastTenseScreen.dart';
import 'PastTenseScreen.dart';

class GrammarRulesScreen extends StatelessWidget {
  final String updateMode;

  GrammarRulesScreen({Key? key, required this.updateMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String titleText = (updateMode == "Modify")
        ? "Choose a Grammar Rule to Modify"
        : "Choose a Grammar Rule";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Choose a Grammar Rule", // Replace with your desired text
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.pink[50]!],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Text(
              titleText,
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontFamily: 'Cursive',
              ),
            ),
            SizedBox(height: 40.0),
            Expanded(
              child: ListView(
                children: [
                  _buildGrammarRuleTile(context, "Past Tense", 0),
                  _buildGrammarRuleTile(context, "Future Tense", 1),
                  _buildGrammarRuleTile(context, "Negatives", 2),
                  _buildGrammarRuleTile(context, "Indirect Speech", 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Define the pastel colors list
  final List<Color> pastelColors = [kgreen, kpink, kpurple, korange, kyellow];

  Widget _buildGrammarRuleTile(BuildContext context, String title, int index) {
    return Card(
      color: pastelColors[index % pastelColors.length],
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (title == "Past Tense") {
            if (updateMode =='') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PastTenseScreen()),
              );
            }else if (updateMode =='Modify') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherPastTenseScreen()),
              );
            }
          } else if (title == "Future Tense"){
            if (updateMode =='') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FutureTenseScreen()),
              );
            }else if (updateMode =='Modify') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherFutureTenseScreen()),
              );
            }
          }else if (title == "Negatives"){
            if (updateMode =='') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NegativeFormScreen()),
              );
            }else if (updateMode =='Modify') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherNegativeFormScreen()),
              );
            }
          }
          else if (title == "Indirect Speech"){
            if (updateMode =='') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IndirectSpeechScreen()),
              );
            }else if (updateMode =='Modify') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherSpeechScreen()),
              );
            }
          }
        },
      ),
    );
  }

}
