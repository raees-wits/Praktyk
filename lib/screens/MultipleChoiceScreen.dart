import 'dart:math';
import 'package:flutter/material.dart';

class MultipleChoiceScreen extends StatefulWidget {
  final String category;

  MultipleChoiceScreen({required this.category});

  @override
  _MultipleChoiceScreenState createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen> {
  final String questionText = "What is the capital of France?"; // You might want to fetch this based on the category later
  List<String> options = ["Paris", "London", "Berlin", "Madrid"];

  @override
  void initState() {
    super.initState();
    options.shuffle(Random());
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == options[0]) {
      // Correct answer
      print("Correct!");
      // TODO: Handle correct answer logic here
    } else {
      // Wrong answer
      print("Wrong. Try again.");
      // TODO: Handle wrong answer logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} - Multiple Choice"), // Now using the category in the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question: $questionText",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Spacer
            ...options.map((option) => OptionButton(option: option, onSelected: checkAnswer)).toList(),
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String option;
  final Function(String) onSelected;

  OptionButton({required this.option, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        onPressed: () {
          onSelected(option);
        },
        child: Text(option),
      ),
    );
  }
}
