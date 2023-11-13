import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import '../../model/current_user.dart';

class DirectSpeechScreen extends StatefulWidget {
  @override
  _DirectSpeechScreenState createState() => _DirectSpeechScreenState();
}

class _DirectSpeechScreenState extends State<DirectSpeechScreen> {
  final TextEditingController answerController = TextEditingController();
  int currentQuestionIndex = 0;
  String? feedback;
  bool? isCorrect;
  double opacityLevel = 0.0;
  bool isLoading = true;

  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestionsFromFirestore();
  }

  Future<void> _fetchQuestionsFromFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final snapshot = await firestore.collection('Indirect Speech').doc('Questions').get();
      final questionsList = snapshot['Questions'];

      if (questionsList is List) {
        setState(() {
          questions = List<Map<String, dynamic>>.from(questionsList);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  void submitAnswer() {
    String userAnswer = answerController.text.trim();
    String correctQuestion = questions[currentQuestionIndex]['Question'];

    // Determine whether the user's answer is correct by comparing it to the 'Question' field
    bool isUserAnswerCorrect = userAnswer.toLowerCase() == correctQuestion.toLowerCase();

    setState(() {
      if (isUserAnswerCorrect) {
        feedback = "Correct!";
        isCorrect = true;
        // Perform any additional logic for correct answer if necessary
      } else {
        // Provide the correct 'Question' as feedback
        feedback = "Incorrect! The correct statement was: $correctQuestion";
        isCorrect = false;
      }
      opacityLevel = 1.0; // Set the opacity to show the feedback immediately
    });

    // If the answer is correct, update the Firestore data
    if (isCorrect == true) {
      final firestore = FirebaseFirestore.instance;
      final CollectionReference usersCollection = firestore.collection('Users');
      String? userId = CurrentUser().userId;

      usersCollection.doc(userId).get().then((docSnapshot) {
        if (docSnapshot.exists) {
          final userData = docSnapshot.data() as Map<String, dynamic>;
          final questionsCompleted = userData['Questions Completed']['Direct Speech'] ?? 0;

          if (questionsCompleted <= currentQuestionIndex) {
            usersCollection.doc(userId).update({
              'Questions Completed.Direct Speech': currentQuestionIndex + 1,
            });
          }
        }
      });
    }

    // Hide the feedback after a delay and clear the answer controller
    Timer(const Duration(seconds: 2), () {
      setState(() {
        opacityLevel = 0.0;
        answerController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9ba0fc),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Direct Speech Questions",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF9ba0fc),
                Color(0xcc9ba0fc),
                Color(0x999ba0fc),
                Color(0x669ba0fc),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  Text(
                    "Question ${currentQuestionIndex + 1}",
                    style: TextStyle(
                      fontFamily: 'Cursive',
                      fontSize: 45,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Write the following question in Direct speech:",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  isLoading
                      ? CircularProgressIndicator()
                      : Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      questions[currentQuestionIndex]['Answers'][0], // Display the first answer as the question as the "Question"
                      style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontSize: 32,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Your answer here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: submitAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Color(0xFF9ba0fc),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (feedback != null)
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          feedback!,
                          style: TextStyle(
                            color: isCorrect! ? Colors.green : Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: opacityLevel,
                          duration: Duration(seconds: 1),
                          child: Icon(
                            isCorrect! ? Icons.check : Icons.close,
                            color: isCorrect! ? Colors.green : Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0x999ba0fc),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (currentQuestionIndex > 0) {
                      setState(() {
                        currentQuestionIndex--;
                        feedback = null;
                        isCorrect = null;
                        answerController.clear();
                      });
                    }
                  },
                  child: Text("Prev"),
                ),
                Text(
                  "Question ${currentQuestionIndex + 1}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentQuestionIndex < questions.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                        feedback = null;
                        isCorrect = null;
                        answerController.clear();
                      });
                    }
                  },
                  child: Text("Next"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
