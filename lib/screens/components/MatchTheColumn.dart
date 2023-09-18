import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class MatchTheColumnPage extends StatefulWidget {
  const MatchTheColumnPage({Key? key}) : super(key: key);

  @override
  _MatchTheColumnPageState createState() => _MatchTheColumnPageState();
}

class _MatchTheColumnPageState extends State<MatchTheColumnPage> {
  List<String> questions = [];
  List<String> answers = [];
  Map<int, int> matchingPairs = {};
  int correctMatches = 0;

  int? selectedQuestionIndex; // Define selectedQuestionIndex
  int? selectedAnswerIndex;   // Define selectedAnswerIndex

  @override
  void initState() {
    super.initState();
    fetchRandomQuestionsAndAnswers();
  }

  Future<void> fetchRandomQuestionsAndAnswers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Match The Column')
          .limit(4) // Fetch 4 random pairs
          .get();

      final random = Random();

      querySnapshot.docs.forEach((doc) {
        questions.add(doc['Question'] as String);
        answers.add(doc['Answer'] as String);
      });

      // Shuffle the questions and answers
      questions.shuffle(random);
      answers.shuffle(random);

      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (BuildContext context, int index) {
                        final question = questions[index];
                        final matchingIndex = matchingPairs[index];
                        final answer =
                        matchingIndex != null ? answers[matchingIndex] : null;

                        return ListTile(
                          title: Text("$index. $question"),
                          subtitle: Text(
                              answer != null ? "${String.fromCharCode(matchingIndex! + 65)}. $answer" : ""),
                        );
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      checkMatchingPairs();
                    },
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkMatchingPairs() async {
    int correctMatchesCount = 0;

    for (int i = 0; i < questions.length; i++) {
      final matchingIndex = matchingPairs[i];

      // Ensure matchingIndex is not null and within bounds
      if (matchingIndex != null && matchingIndex >= 0 && matchingIndex < answers.length) {
        final matchingAnswer = answers[matchingIndex];
        final originalQuestion = questions[i]; // Use the original question

        // Fetch the document IDs for the Question and Answer
        final questionQuery = await FirebaseFirestore.instance
            .collection('Match The Column')
            .where('Question', isEqualTo: originalQuestion)
            .limit(1)
            .get();

        final answerQuery = await FirebaseFirestore.instance
            .collection('Match The Column')
            .where('Answer', isEqualTo: matchingAnswer)
            .limit(1)
            .get();

        if (questionQuery.docs.isNotEmpty && answerQuery.docs.isNotEmpty) {
          final questionDocumentId = questionQuery.docs[0].id;
          final answerDocumentId = answerQuery.docs[0].id;

          // Check if the document IDs match
          if (questionDocumentId == answerDocumentId) {
            correctMatchesCount++;
          }
        }
      }
    }

    setState(() {
      correctMatches = correctMatchesCount;
    });

    print("Correct Matches: $correctMatchesCount");
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
