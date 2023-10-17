import 'package:flutter/material.dart';
import 'package:e_learning_app/screens/practise_vocab_screen.dart'; // ensure you import the PracticeVocabularyScreen

class TeacherChoiceScreen extends StatelessWidget {
  const TeacherChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Choices'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to the PracticeVocabularyScreen when this is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PracticeVocabularyScreen(updateMode: '',)),
                );
              },
              child: Text('View Student Perspective'), // change the button text
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the "Add Questions" screen when this is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PracticeVocabularyScreen(updateMode: 'Add',)),
                );
              },
              child: Text('Add Questions'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the "Add Questions" screen when this is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PracticeVocabularyScreen(updateMode: 'Modify',)),
                );
              },
              child: Text('Modify Questions'),
            ),
          ],
        ),
      ),
    );
  }
}
