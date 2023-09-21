import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class MatchTheColumnPage extends StatefulWidget {
  final String categoryName;
  const MatchTheColumnPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  _MatchTheColumnPageState createState() => _MatchTheColumnPageState();
}

class _MatchTheColumnPageState extends State<MatchTheColumnPage> {
  List<String> questions = [];
  List<String> answers = [];
  Map<int, int> matchingPairs = {};
  int correctMatches = 0;

  List<Color> questionButtonColors = []; // List to store colors of question buttons
  List<Color> answerButtonColors = []; // List to store colors of answer buttons
  int? selectedQuestionIndex;
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    fetchRandomQuestionsAndAnswers();
  }

  Future<void> fetchRandomQuestionsAndAnswers() async {
    try {
      final categoryDoc = await FirebaseFirestore.instance
          .collection('Match The Column')
          .doc(widget.categoryName)
          .get();

      if (categoryDoc.exists) {
        final data = categoryDoc.data() as Map<String, dynamic>;
        final questionsMap = data['Questions'] as Map<String, dynamic>;

        questionsMap.forEach((question, answer) {
          questions.add(question);
          answers.add(answer);
        });

        // Shuffle the questions and answers
        final random = Random();
        questions.shuffle(random);
        answers.shuffle(random);

        // Initialize questionButtonColors and answerButtonColors with different colors
        questionButtonColors = List.generate(questions.length, (index) {
          switch (index) {
            case 0:
              return Colors.red;
            case 1:
              return Colors.blue;
            case 2:
              return Colors.yellow;
            case 3:
              return Colors.green;
            default:
              return Colors.white;
          }
        });

        answerButtonColors = List.generate(answers.length, (index) {
          return Colors.white; // Initially, all answer buttons are white
        });

        setState(() {});
      } else {
        print('Category not found');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Column buildQuestionColumn() {
    return Column(
      children: [
        const Text(
          "Questions",
          style: TextStyle(
            fontSize: 24,
            color: Colors.blue,
          ),
        ),
        for (int i = 0; i < questions.length; i++) buildQuestion(i),
      ],
    );
  }

  Column buildAnswerColumn() {
    return Column(
      children: [
        const Text(
          "Answers",
          style: TextStyle(
            fontSize: 24,
            color: Colors.green,
          ),
        ),
        for (int i = 0; i < answers.length; i++) buildAnswer(i),
      ],
    );
  }

  String resultMessage = ""; // Store the result message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: GestureDetector(
        onTap: () {
          // Handle taps on the entire screen if needed
        },
        child: Column(
          children: [
            const SizedBox(height: 40), // Add spacing between the top of the page and the columns
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding on all sides
              child: Container(
                width: double.infinity, // Set the width to match the screen width
                child: Row(
                  children: [
                    // Left Column - Questions
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Border color
                            width: 2.0, // Border width (adjust as needed)
                          ),
                        ),
                        child: buildQuestionColumn(),
                      ),
                    ),
                    // Right column - Answers
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Border color
                            width: 2.0, // Border width (adjust as needed)
                          ),
                        ),
                        child: buildAnswerColumn(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Add spacing between questions/answers and matchings
            const Text(
              "Matchings:",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Remove the outer Expanded widget from the "Matchings" section
            Column(
              children: [
                Wrap(
                  //runSpacing: 5.0, // Add spacing between rows
                  children: List.generate(questions.length, (index) {
                    final question = questions[index];
                    final matchingIndex = matchingPairs[index];
                    final answer =
                    matchingIndex != null ? answers[matchingIndex] : null;

                    return Container(
                      width: MediaQuery.of(context).size.width / 2, // Set the width to half the screen width for 2 items per row
                      child: ListTile(
                        title: Text("$index. $question"),
                        subtitle: Text(
                            answer != null ? "${String.fromCharCode(matchingIndex! + 65)}. $answer" : ""),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10), // Add spacing between "Matchings" and "Confirm" button
                TextButton(
                  onPressed: () {
                    checkMatchingPairs();
                    // Display the result message when the button is clicked
                    setState(() {
                      resultMessage = "You have $correctMatches correct matches";
                    });
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                ),
                // Display the result message under the button
                Text(
                  resultMessage,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green, // You can choose your desired color
                  ),
                ),
              ],
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

  void pairSelected() {
    if (selectedQuestionIndex != null && selectedAnswerIndex != null) {
      matchingPairs[selectedQuestionIndex!] = selectedAnswerIndex!;
      answerButtonColors[selectedAnswerIndex!] = questionButtonColors[selectedQuestionIndex!];
      // Remove the color change from here
      // selectedQuestionIndex = null;
      selectedAnswerIndex = null;
    }
  }


  Widget buildQuestion(int index) {
    final isMatched = matchingPairs.containsKey(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedQuestionIndex = index;
          pairSelected();
        });
        print("Selected Question X: ${index * 40.0}");
      },
      child: SizedBox(
        width: double.infinity, // Set the width to match the column
        height: 50, // Set your desired height
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Border color
              width: 1.0, // Border width
            ),
            color: isMatched
                ? questionButtonColors[index]
                : (selectedQuestionIndex == index
                ? questionButtonColors[index]
                : Colors.white),
          ),
          child: Center(
            child: Text(
              questions[index],
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAnswer(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswerIndex = index;
          pairSelected();
        });
        print("Selected Answer X: ${(index + 2) * 40.0}");
      },
      child: SizedBox(
        width: double.infinity, // Set the width to match the column
        height: 50, // Set your desired height
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black, // Border color
              width: 1.0, // Border width
            ),
            color: selectedAnswerIndex == index
                ? questionButtonColors[selectedQuestionIndex ?? 0]
                : answerButtonColors[index],
          ),
          child: Center(
            child: Text(
              answers[index],
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }



}

void main() {
  runApp(const MaterialApp(
    home: MatchTheColumnPage(categoryName: ''),
  ));
}