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
  int selectedQuestionIndex = -1;
  int selectedAnswerIndex = -1;

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
        child: Stack(
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
            // Draw lines using CustomPaint
            CustomPaint(
              painter: LinePainter(
                selectedQuestionIndex,
                selectedAnswerIndex,
                columnCount: 2, // Number of columns
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
          selectedQuestionIndex = index;
        });
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
          selectedAnswerIndex = index;
        });
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

class LinePainter extends CustomPainter {
  final int selectedQuestionIndex;
  final int selectedAnswerIndex;
  final int columnCount;

  LinePainter(this.selectedQuestionIndex, this.selectedAnswerIndex, {required this.columnCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    if (selectedQuestionIndex != -1 && selectedAnswerIndex != -1) {
      final start = Offset(
        size.width / (columnCount + 1), // Divide the screen into columns
        50.0 + selectedQuestionIndex * 40,
      );
      final end = Offset(
        size.width - (size.width / (columnCount + 1)),
        50.0 + selectedAnswerIndex * 40,
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

void main() {
  runApp(MaterialApp(
    home: MatchTheColumnPage(),
  ));
}
