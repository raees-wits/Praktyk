import 'package:flutter/material.dart';

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
                // TODO: Navigate to the "View Questions" screen when this is pressed
              },
              child: Text('View Questions'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to the "Add Questions" screen when this is pressed
              },
              child: Text('Add Questions'),
            ),
          ],
        ),
      ),
    );
  }
}
