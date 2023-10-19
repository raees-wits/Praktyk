import 'package:flutter/material.dart';
import 'package:e_learning_app/screens/practise_vocab_screen.dart'; // ensure you import the PracticeVocabularyScreen

class TeacherChoiceScreen extends StatelessWidget {
  const TeacherChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // A method to create a button with a gradient background
    Widget buildGradientButton({required VoidCallback onPressed, required String text, required List<Color> colors}) {
      return Container(
        width: double.infinity, // makes the buttons take up all available space
        margin: EdgeInsets.all(8.0), // adds spacing around the buttons
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), // if you want rounded corners
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adds padding on the left and right of the buttons
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildGradientButton(
                onPressed: () {
                  // Navigate to the PracticeVocabularyScreen when this is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PracticeVocabularyScreen(updateMode: '',)),
                  );
                },
                text: 'View Student Perspective', // change the button text
                colors: [Colors.blue, Colors.purple], // colors for the gradient
              ),
              buildGradientButton(
                onPressed: () {
                  // TODO: Navigate to the "Add Questions" screen when this is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PracticeVocabularyScreen(updateMode: 'Add',)),
                  );
                },
                text: 'Add Questions',
                colors: [Colors.red, Colors.orange], // different colors for the gradient
              ),
              buildGradientButton(
                onPressed: () {
                  // TODO: Navigate to the "Modify Questions" screen when this is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PracticeVocabularyScreen(updateMode: 'Modify',)),
                  );
                },
                text: 'Modify Questions',
                colors: [Colors.green, Colors.teal], // another set of colors for the gradient
              ),
            ],
          ),
        ),
      ),
    );
  }
}
