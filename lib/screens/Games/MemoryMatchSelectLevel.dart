import 'package:flutter/material.dart';

import 'memoryMatchScreen.dart';

void main() {
  runApp(MaterialApp(home: MemoryMatchLevelSelect()));
}

class MemoryMatchLevelSelect extends StatefulWidget {
  @override
  _MemoryMatchLevelSelectState createState() => _MemoryMatchLevelSelectState();
}

class _MemoryMatchLevelSelectState extends State<MemoryMatchLevelSelect> {
  void navigateToMemoryMatch(String level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoryMatch(level: level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use the widest button's width as the standard for all buttons.
    double buttonWidth = MediaQuery.of(context).size.width * 0.2; // For example, 80% of screen width

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
        backgroundColor: Colors.yellow,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttonWidth),
              child: ElevatedButton(
                child: Text('Easy'),
                onPressed: () => navigateToMemoryMatch("easy"),
              ),
            ),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttonWidth),
              child: ElevatedButton(
                child: Text('Medium'),
                onPressed: () => navigateToMemoryMatch("medium"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}