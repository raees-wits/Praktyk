import 'package:e_learning_app/screens/activity_short_answer.dart';
import 'package:e_learning_app/screens/comprehension_choice_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/screens/fill_in_blanks_screen.dart';
import 'package:e_learning_app/screens/category_tree.dart';

import '../../model/category_modal.dart';
import 'TeacherScreens/teacher_match_the_column_screen.dart';

class PracticeVocabularyScreen extends StatelessWidget {
  final String updateMode;

  PracticeVocabularyScreen({Key? key, required this.updateMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Set the arrow icon color
          onPressed: () =>
              Navigator.of(context).pop(), // Pop the current screen
        ),
        title: Text(
          updateMode == "Add" ? "Add Questions" : (updateMode == "Modify" ? "Modify Questions" : "Pick a choice"),
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
              "Kies een!",
              style: TextStyle(
                fontSize: 50, // Increased font size
                color: Colors.white,
                fontFamily: 'Cursive',
              ),
            ),
            SizedBox(height: 40.0),
            Expanded(
              child: ListView(
                children: [
                  _buildChoiceTile(context, "Fill in the blanks", 0),
                  _buildChoiceTile(context, "Multiple Choice", 1),
                  _buildChoiceTile(context, "Short Questions", 2),
                  _buildChoiceTile(context, "Match The Column", 3),
                  _buildChoiceTile(context, "Comprehension Texts", 4),
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

  Widget _buildChoiceTile(BuildContext context, String title, int index) {
    return Card(
      color: pastelColors[index % pastelColors.length],
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (title == "Fill in the blanks") {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FillInTheBlanksScreen()),
            );
          } else if (title == "Match The Column") {
            if (updateMode == "Add" || updateMode == "Modify") {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    TeacherMatchTheColumn(updateMode: updateMode), // Passing updateMode to the new screen
              ));
            }else{
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CategoryTree(
                      categories: categories,
                    ),
              ));
            }
          }else if (title == "Short Questions") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShortAnswerQuestions(),
              ),
            );
          } else if (title == "Comprehension Texts") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ComprehensionChoiceScreen()),
            );
          }
        },
      ),
    );
  }
}
