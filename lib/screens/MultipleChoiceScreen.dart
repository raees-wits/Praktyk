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
  int currentQuestionIndex = 0;
  late List<String> questionKeys;

  @override
  void initState() {
    super.initState();
    _fetchQuestionData();
  }

  Future<void> _fetchQuestionData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('MultipleChoice')
        .doc(widget.category)
        .get();
    Map<String, dynamic> questionsMap =
        (doc.data() as Map<String, dynamic>)?['Questions'] ?? {};
    questionKeys = questionsMap.keys.toList();
    _loadCurrentQuestion(questionsMap);
  }

  void _loadCurrentQuestion(Map<String, dynamic> questionsMap) {
    setState(() {
      questionText = questionKeys[currentQuestionIndex];
      options = List<String>.from(questionsMap[questionText] ?? []);
      correctAnswer = options[0];
      options.shuffle();
    });
  }

  void goToNextQuestion(Map<String, dynamic> questionsMap) {
    if (currentQuestionIndex < questionKeys.length - 1) {
      currentQuestionIndex++;
      _loadCurrentQuestion(questionsMap);
    }
  }

  void goToPreviousQuestion(Map<String, dynamic> questionsMap) {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      _loadCurrentQuestion(questionsMap);
    }
  }

  // Add the feedback dialog method
  void _showFeedbackDialog(String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          backgroundColor: color,
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == correctAnswer) {
      _showFeedbackDialog('Correct!', Colors.green); // Correct answer
    } else {
      _showFeedbackDialog('Wrong. Try again.', Colors.red); // Wrong answer
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
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("${widget.category} - Multiple Choice"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[200]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 40.0),
              Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[800]!, width: 2.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  "Question: $questionText",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              SizedBox(height: 25.0),
              ...options
                  .map((option) =>
                      OptionButton(option: option, onSelected: checkAnswer))
                  .toList(),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        DocumentSnapshot doc = await FirebaseFirestore.instance
                            .collection('MultipleChoice')
                            .doc(widget.category)
                            .get();
                        Map<String, dynamic> questionsMap = (doc.data()
                                as Map<String, dynamic>)?['Questions'] ??
                            {};
                        goToPreviousQuestion(questionsMap);
                      },
                      child: Text("Back"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        DocumentSnapshot doc = await FirebaseFirestore.instance
                            .collection('MultipleChoice')
                            .doc(widget.category)
                            .get();
                        Map<String, dynamic> questionsMap = (doc.data()
                                as Map<String, dynamic>)?['Questions'] ??
                            {};
                        goToNextQuestion(questionsMap);
                      },
                      child: Text("Next"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
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
    return GestureDetector(
      onTap: () {
        onSelected(option);
      },
      child: Card(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 150, height: 60),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                option,
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
