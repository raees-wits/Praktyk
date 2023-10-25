import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MultipleChoiceScreen extends StatefulWidget {
  final String category;

  MultipleChoiceScreen({required this.category});

  @override
  _MultipleChoiceScreenState createState() => _MultipleChoiceScreenState();
}

class _MultipleChoiceScreenState extends State<MultipleChoiceScreen> {
  late String questionText;
  late List<String> options;
  late String correctAnswer;

  @override
  void initState() {
    super.initState();
    _fetchQuestionData();
  }

  Future<void> _fetchQuestionData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('MultipleChoice').doc(widget.category).get();
    Map<String, dynamic> questionsMap = (doc.data() as Map<String, dynamic>)?['Questions'] ?? {};

    questionText = questionsMap.keys.first;  // Assuming you want the first question
    options = List<String>.from(questionsMap[questionText] ?? []);
    correctAnswer = options[0];  // Store the correct answer before shuffling
    options.shuffle();
    setState(() {});  // Rebuild the widget with the new data
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == correctAnswer) {
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
    if (options == null || questionText == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} - Multiple Choice"),
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
            SizedBox(height: 20),
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
