import 'package:flutter/material.dart';
import 'package:e_learning_app/constants.dart';

class GrammarRulesScreen extends StatelessWidget {
  final String updateMode;

  GrammarRulesScreen({Key? key, required this.updateMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "Grammar Rules", // Replace with your desired title
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
              "Choose a Grammar Rule", // Replace with your desired text
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
                  _buildGrammarRuleTile(context, "Past Tense", 0),
                  _buildGrammarRuleTile(context, "Future Tense", 1),
                  _buildGrammarRuleTile(context, "Negatives", 2),
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

  Widget _buildGrammarRuleTile(BuildContext context, String title, int index) {
    return Card(
      color: pastelColors[index % pastelColors.length], // Change the color as desired
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          // Handle the navigation for each grammar rule
          // For example, navigate to specific screens or perform actions based on the selected rule.
          // You can use a similar logic as in the PracticeVocabularyScreen.
        },
      ),
    );
  }
}
