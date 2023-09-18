import 'package:flutter/material.dart';

class MatchTheColumnPage extends StatefulWidget {
  @override
  _MatchTheColumnPageState createState() => _MatchTheColumnPageState();
}

class _MatchTheColumnPageState extends State<MatchTheColumnPage> {
  // Lists to hold questions and answers
  List<String> questions = ["Question 1", "Question 2", "Question 3"];
  List<String> answers = ["Answer 1", "Answer 2", "Answer 3"];

  // Selected question and answer indices
  int? selectedQuestionIndex;
  int? selectedAnswerIndex;

  // Map to store matching pairs
  Map<int, int> matchingPairs = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match the Column"),
      ),
      body: GestureDetector(
        onTap: () {
          // Handle taps on the entire screen if needed
        },
        child: Column(
          children: [
            Row(
              children: [
                // Left Column - Questions
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        "Questions",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.blue,
                        ),
                      ),
                      for (int i = 0; i < questions.length; i++)
                        buildQuestion(i),
                    ],
                  ),
                ),
                // Right Column - Answers
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        "Answers",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green,
                        ),
                      ),
                      for (int i = 0; i < answers.length; i++)
                        buildAnswer(i),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Add spacing between questions/answers and matchings
            Text(
              "Matchings:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  final question = questions[index];
                  final matchingIndex = matchingPairs[index];
                  final answer = matchingIndex != null ? answers[matchingIndex] : null;

                  return ListTile(
                    title: Text("$index. $question"),
                    subtitle: Text(answer != null ? "${String.fromCharCode(matchingIndex! + 65)}. $answer" : ""),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildQuestion(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedAnswerIndex != null) {
            matchingPairs[index] = selectedAnswerIndex!;
            selectedQuestionIndex = null;
            selectedAnswerIndex = null;
          } else {
            selectedQuestionIndex = index;
          }
        });
        print("Selected Question X: ${index * 40.0}");
      },
      child: Container(
        padding: EdgeInsets.all(8),
        color: selectedQuestionIndex == index ? Colors.blue : Colors.white,
        child: Text(
          questions[index],
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget buildAnswer(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedQuestionIndex != null) {
            matchingPairs[selectedQuestionIndex!] = index;
            selectedQuestionIndex = null;
            selectedAnswerIndex = null;
          } else {
            selectedAnswerIndex = index;
          }
        });
        print("Selected Answer X: ${(index + 2) * 40.0}");
      },
      child: Container(
        padding: EdgeInsets.all(8),
        color: selectedAnswerIndex == index ? Colors.green : Colors.white,
        child: Text(
          answers[index],
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MatchTheColumnPage(),
  ));
}
