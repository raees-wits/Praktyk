import 'package:flutter/material.dart';
import 'package:e_learning_app/constants.dart';

class PracticeVocabularyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Pick a choice",
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
            colors: [Colors.red[300]!, Colors.pink[50]!],
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
                  _buildChoiceTile("Fill in the blanks", 0),
                  _buildChoiceTile("Multiple Choice", 1),
                  _buildChoiceTile("Short Questions", 2),
                  _buildChoiceTile("Choice 4", 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Define the pastel colors list
  final List<Color> pastelColors = [kgreen, kblue, kpurple, korange];

  Widget _buildChoiceTile(String title, int index) {
    return Card(
      color: pastelColors[index % pastelColors.length],
      // Set the background color
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Handle the tile tap here
        },
      ),
    );
  }
}

