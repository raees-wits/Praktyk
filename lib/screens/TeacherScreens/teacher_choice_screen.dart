import 'package:e_learning_app/screens/GrammarScreens/GrammarRulesScreen.dart';
import 'package:e_learning_app/screens/TeacherScreens/teacher_comprehension_screen.dart';
import 'package:e_learning_app/screens/comprehension_choice_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/screens/practise_vocab_screen.dart'; // ensure you import the PracticeVocabularyScreen

class TeacherChoiceScreen extends StatelessWidget {
  final String screen;

  TeacherChoiceScreen({required this.screen});

  @override
  Widget build(BuildContext context) {
    // A method to create a button with a gradient background
    Widget buildGradientButton(
        {required VoidCallback onPressed,
        required String text,
        required List<Color> colors}) {
      return Container(
        width: double.infinity, // makes the buttons take up all available space
        margin: EdgeInsets.all(8.0), // adds spacing around the buttons
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(8.0), // if you want rounded corners
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Choices'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal:
                  16.0), // Adds padding on the left and right of the buttons
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildGradientButton(
                onPressed: () {
                  if (screen == "Vocabulary") {
                    // Navigate to the PracticeVocabularyScreen when this is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PracticeVocabularyScreen(
                                updateMode: '',
                              )),
                    );
                  } else if (screen == "Grammar") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GrammarRulesScreen(updateMode: '')),
                    );
                  } else if (screen == "Comprehension") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComprehensionChoiceScreen()));
                  }
                },
                text: 'View Student Perspective', // change the button text
                colors: [Colors.blue, Colors.purple], // colors for the gradient
              ),
              buildGradientButton(
                onPressed: () {
                  if (screen == "Vocabulary") {
                    // Navigate to the PracticeVocabularyScreen when this is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PracticeVocabularyScreen(
                                updateMode: 'Modify',
                              )),
                    );
                  } else if (screen == "Grammar") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GrammarRulesScreen(updateMode: 'Modify')),
                    );
                  } else if (screen == "Comprehension") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TeacherComprehensionChoiceScreen()));
                  }
                },
                text: 'Add/Modify Questions',
                colors: [
                  Colors.green,
                  Colors.teal
                ], // another set of colors for the gradient
              ),
            ],
          ),
        ),
      ),
    );
  }
}
