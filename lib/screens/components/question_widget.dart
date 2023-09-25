import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer_widget.dart';

class QuestionWidget extends StatelessWidget {
  final String questionId;
  final String questionText;

  Future<void> _upvoteAnswer(String questionId, String answerId) async {
    final answerRef = FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .doc(answerId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final answerDoc = await transaction.get(answerRef);
      final currentUpvotes = answerDoc['upvotes'] ?? 0;
      transaction.update(answerRef, {'upvotes': currentUpvotes + 1});
    });
  }

  Future<void> _downvoteAnswer(String questionId, String answerId) async {
    final answerRef = FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .doc(answerId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final answerDoc = await transaction.get(answerRef);
      final currentDownvotes = answerDoc['downvotes'] ?? 0;
      transaction.update(answerRef, {'downvotes': currentDownvotes + 1});
    });
  }




  QuestionWidget({required this.questionId, required this.questionText});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: questionHasImage(questionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.data!) {
          // Handle the case where there's an error or no image is found
          return Card(
            margin: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Rest of your widget contents
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    questionText,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    "Asked by John Doe",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showAnswerDialog(context);
                        },
                        child: Text("Answer this question"),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text(
                    "Answers",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('questions')
                          .doc(questionId)
                          .collection('answers')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        final answers = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: answers.length,
                          itemBuilder: (context, index) {
                            final answerDoc = answers[index];
                            final answerText = answerDoc['text'];
                            final upvotes = answerDoc['upvotes'];
                            final downvotes = answerDoc['downvotes'];

                            return AnswerWidget(
                              answer: answerText,
                              upvotes: upvotes,
                              downvotes: downvotes,
                              onUpvote: () async {
                                await _upvoteAnswer(questionId, answerDoc.id);
                              },
                              onDownvote: () async {
                                await _downvoteAnswer(questionId, answerDoc.id);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          // If the question has an image, display the "View Attached Image" link
          return Card(
            margin: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Rest of your widget contents
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    questionText,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    "Asked by John Doe",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // View Attached Image Link
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'View Attached Image',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _showAttachedImage(context, questionId);
                        },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showAnswerDialog(context);
                        },
                        child: Text("Answer this question"),
                      ),
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text(
                    "Answers",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('questions')
                          .doc(questionId)
                          .collection('answers')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        final answers = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: answers.length,
                          itemBuilder: (context, index) {
                            final answerDoc = answers[index];
                            final answerText = answerDoc['text'];
                            final upvotes = answerDoc['upvotes'];
                            final downvotes = answerDoc['downvotes'];

                            return AnswerWidget(
                              answer: answerText,
                              upvotes: upvotes,
                              downvotes: downvotes,
                              onUpvote: () async {
                                await _upvoteAnswer(questionId, answerDoc.id);
                              },
                              onDownvote: () async {
                                await _downvoteAnswer(questionId, answerDoc.id);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }



  void _showAnswerDialog(BuildContext context) {
    String answerText = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Answer this question"),
          content: TextField(
            onChanged: (text) {
              answerText = text;
            },
            decoration: InputDecoration(
              hintText: "Type your answer here...",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () async {
                if (answerText.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('questions')
                      .doc(questionId)
                      .collection('answers')
                      .add({
                    'text': answerText,
                    'upvotes': 0, // Initial upvotes count
                    'downvotes': 0, // Initial downvotes count
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> questionHasImage(String questionId) {
    // Reference to the Firestore document for the specific question
    final questionRef =
    FirebaseFirestore.instance.collection('questions').doc(questionId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
      // Get the question document snapshot
      final questionDoc = await transaction.get(questionRef);

      // Check if the 'imageUrl' field exists in the question document
      if (questionDoc.exists && questionDoc.data() != null) {
        final data = questionDoc.data() as Map<String, dynamic>;
        return data.containsKey('imageUrl') && data['imageUrl'] != null;
      }

      // If the document doesn't exist or has no data, return false
      return false;
    })
        .then((hasImage) {
      // Return the result of the transaction
      return hasImage ?? false;
    })
        .catchError((error) {
      // Handle any errors that may occur during the transaction
      print('Error checking for image: $error');
      return false;
    });
  }

  void _showAttachedImage(BuildContext context, String questionId) {
    FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .get()
        .then((questionDoc) {
      if (questionDoc.exists) {
        final data = questionDoc.data() as Map<String, dynamic>;
        final imageUrl = data['imageUrl'] as String?;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          // Display the attached image in a dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(imageUrl), // Display the image using the URL
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          // If there's no image URL, show an error message or handle it as needed
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('No Attached Image'),
                content: Text('This question does not have an attached image.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle the case where the question document does not exist
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Question Not Found'),
              content: Text('The question associated with this image was not found.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }).catchError((error) {
      // Handle any errors that may occur while fetching the question document
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while fetching the image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print('Error fetching image: $error');
    });
  }


}