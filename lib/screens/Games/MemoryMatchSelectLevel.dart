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
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Easy'),
              onPressed: () => navigateToMemoryMatch("easy"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Medium'),
              onPressed: () => navigateToMemoryMatch("medium"),
            ),
          ],
        ),
      ),
    );
  }
}

// Add modifications to your MemoryMatch and CardModel classes to support level selection.
