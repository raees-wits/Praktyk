import 'package:e_learning_app/screens/GrammarScreens/GrammarRulesScreen.dart';
import 'package:e_learning_app/screens/TeacherScreens/teacher_comprehension_screen.dart';
import 'package:e_learning_app/screens/comprehension_choice_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/screens/practise_vocab_screen.dart';

class TeacherChoiceScreen extends StatelessWidget {
  final String screen;

  TeacherChoiceScreen({required this.screen});

  @override
  Widget build(BuildContext context) {
    Widget buildGradientButton(
        {required VoidCallback onPressed,
        required String text,
        required List<Color> colors}) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(8.0),
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
                  16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildGradientButton(
                onPressed: () {
                  if (screen == "Vocabulary") {
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
                text: 'View Student Perspective',
                colors: [Colors.blue, Colors.purple],
              ),
              buildGradientButton(
                onPressed: () {
                  if (screen == "Vocabulary") {

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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
