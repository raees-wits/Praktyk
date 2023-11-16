import 'package:e_learning_app/screens/GrammarScreens/DirectSpeechScreen.dart';
import 'package:e_learning_app/screens/GrammarScreens/FutureTenseScreen.dart';
import 'package:e_learning_app/screens/GrammarScreens/IndirectSpeechScreen.dart';
import 'package:e_learning_app/screens/GrammarScreens/NegativeFormScreen.dart';
import 'package:e_learning_app/screens/GrammarScreens/ActiveFormScreen.dart';
import 'package:e_learning_app/screens/GrammarScreens/STOMPIScreen.dart';
import 'package:e_learning_app/screens/TeacherScreens/teacherActivePassiveScreen.dart';
import 'package:e_learning_app/screens/TeacherScreens/teacherFutureTenseScreen.dart';
import 'package:e_learning_app/screens/TeacherScreens/teacherSpeechScreen.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/constants.dart';

import '../TeacherScreens/teacherNegativeFormScreen.dart';
import '../TeacherScreens/teacherPastTenseScreen.dart';
import 'PassiveFormScreen.dart';
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
          titleText,
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
                  _buildGrammarRuleTile(context, "Past Tense", 0, updateMode),
                  _buildGrammarRuleTile(context, "Future Tense", 1, updateMode),
                  _buildGrammarRuleTile(context, "Negatives", 2, updateMode),
                  _buildGrammarRuleTile(context, "Indirect Speech", 3, updateMode),
                  _buildGrammarRuleTile(context, "Direct Speech", 0, updateMode),
                  if (updateMode != "Modify") _buildGrammarRuleTile(context, "STOMPI", 1, updateMode),
                  _buildGrammarRuleTile(context, "Active Form", 2, updateMode),
                  _buildGrammarRuleTile(context, "Passive Form", 3, updateMode),
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

  Widget _buildGrammarRuleTile(BuildContext context, String title, int index, String updateMode) {
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
            navigateToScreen(context, updateMode, PastTenseScreen(), TeacherPastTenseScreen());
          } else if (title == "Future Tense") {
            navigateToScreen(context, updateMode, FutureTenseScreen(), TeacherFutureTenseScreen());
          } else if (title == "Negatives") {
            navigateToScreen(context, updateMode, NegativeFormScreen(), TeacherNegativeFormScreen());
          } else if (title == "Indirect Speech") {
            navigateToScreen(context, updateMode, IndirectSpeechScreen(), TeacherSpeechScreen());
          } else if (title == "Direct Speech") {
            navigateToScreen(context, updateMode, DirectSpeechScreen(), TeacherSpeechScreen());
          } else if (title == "STOMPI") {
            navigateToScreen(context, updateMode, STOMPIScreen(), STOMPIScreen());
          } else if (title == "Active Form") {
            navigateToScreen(context, updateMode, ActiveScreen(), TeacherActivePassiveScreen());
          } else if (title == "Passive Form") {
            navigateToScreen(context, updateMode, PassiveScreen(), TeacherActivePassiveScreen());
          }
        },
      ),
    );
  }

  void navigateToScreen(BuildContext context, String updateMode, Widget defaultScreen, Widget modifyScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => updateMode == "Modify" ? modifyScreen : defaultScreen),
    );
  }
}
