import 'package:e_learning_app/model/current_user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer_widget.dart';

class QuestionWidget extends StatelessWidget {
  final String questionId;
  final String questionText;

  Future<void> _upvoteAnswer(String questionId, String answerId) async {
    final userVoteRef = FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .doc(answerId)
        .collection('votes')
        .doc(CurrentUser().userId);

    final DocumentSnapshot userVoteSnapshot = await userVoteRef.get();

    Map<String, dynamic>? userVoteData = userVoteSnapshot.data() as Map<String, dynamic>?;

    if (userVoteSnapshot.exists && userVoteData?['voteType'] == 'upvote') {
      print('User has already upvoted');
      return;
    }

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final answerRef = FirebaseFirestore.instance
          .collection('questions')
          .doc(questionId)
          .collection('answers')
          .doc(answerId);

      final answerDoc = await transaction.get(answerRef);
      final answerData = answerDoc.data();
      final currentUpvotes = (answerData != null ? answerData['upvotes'] : 0) ?? 0;
      final currentDownvotes = (answerData != null ? answerData['downvotes'] : 0) ?? 0;

      // If user previously downvoted, remove downvote and increment upvotes
      if (userVoteSnapshot.exists && userVoteData?['voteType'] == 'downvote') {
        transaction.update(answerRef, {
          'upvotes': currentUpvotes + 1,
          'downvotes': currentDownvotes > 0 ? currentDownvotes - 1 : 0
        });
      } else {
        // If there was no previous vote or it wasn't a downvote, just increment upvotes
        transaction.update(answerRef, {
          'upvotes': currentUpvotes + 1
        });
      }

      // Set or update the user's vote to upvote
      transaction.set(userVoteRef, {
        'userId': CurrentUser().userId,
        'voteType': 'upvote',
      });
    });
  }



  Future<void> _downvoteAnswer(String questionId, String answerId) async {
    final userVoteRef = FirebaseFirestore.instance
        .collection('questions')
        .doc(questionId)
        .collection('answers')
        .doc(answerId)
        .collection('votes')
        .doc(CurrentUser().userId); // assuming this is how you access the current user's ID

    final DocumentSnapshot userVoteSnapshot = await userVoteRef.get();

    if (userVoteSnapshot.exists) {
      // Check if the user has already downvoted
      Map<String, dynamic>? userVoteData = userVoteSnapshot.data() as Map<String, dynamic>?;

      if (userVoteSnapshot.exists && userVoteData?['voteType'] == 'downvote') {
        print('User has already downvoted');
        return;
      }

      // If previously upvoted, remove upvote as part of downvoting process
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final answerRef = FirebaseFirestore.instance
            .collection('questions')
            .doc(questionId)
            .collection('answers')
            .doc(answerId);

        final answerDoc = await transaction.get(answerRef);
        final answerData = answerDoc.data();
        final currentUpvotes = (answerData != null ? answerData['upvotes'] : 0) ?? 0;
        final currentDownvotes = (answerData != null ? answerData['downvotes'] : 0) ?? 0;

        // If user previously upvoted, decrement upvotes
        if (userVoteSnapshot.exists && userVoteData?['voteType'] == 'upvote') {
          transaction.update(answerRef, {
            'upvotes': currentUpvotes - 1,
            'downvotes': currentDownvotes + 1
          });
        } else {
          // Or else just increment downvotes
          transaction.update(answerRef, {'downvotes': currentDownvotes + 1});
        }

        // Finally, update the user's vote to downvote
        transaction.set(userVoteRef, {
          'userId': CurrentUser().userId,
          'voteType': 'downvote',
        });
      });
    } else {
      // If the user hasn't voted before, just add the downvote
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final answerRef = FirebaseFirestore.instance
            .collection('questions')
            .doc(questionId)
            .collection('answers')
            .doc(answerId);

        final answerDoc = await transaction.get(answerRef);
        final currentDownvotes = answerDoc['downvotes'] ?? 0;

        // Increment the downvotes and add the user's vote to the sub-collection
        transaction.update(answerRef, {'downvotes': currentDownvotes + 1});
        transaction.set(userVoteRef, {
          'userId': CurrentUser().userId,
          'voteType': 'downvote',
        });
      });
    }
  }





  QuestionWidget({required this.questionId, required this.questionText});

  Widget buildCard(BuildContext context, bool hasImage) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
          if (hasImage)
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
          if (CurrentUser().userType == 'Teacher')
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
                      final answerData = answers[index].data() as Map<String, dynamic>;
                      final answerText = answerData['text'];
                      final upvotes = answerData['upvotes'];
                      final downvotes = answerData['downvotes'];
                      final userName = answerData.containsKey('user_name') && answerData['user_name'] != null && answerData['user_name'].isNotEmpty
                          ? answerData['user_name']
                          : 'anonymous';
                      return AnswerWidget(
                        answer: answerText,
                        upvotes: upvotes,
                        downvotes: downvotes,
                        posterName:userName,
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


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: questionHasImage(questionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.data!) {
          // Handle the case where there's an error or no image is found
          return buildCard(context, false);
        } else {
          // If the question has an image, display the "View Attached Image" link
          return buildCard(context, true);
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
                  String? currentUserFirstName = CurrentUser().firstName;
                  await FirebaseFirestore.instance
                      .collection('questions')
                      .doc(questionId)
                      .collection('answers')
                      .add({
                    'text': answerText,
                    'upvotes': 0, // Initial upvotes count
                    'downvotes': 0, // Initial downvotes count
                    'timestamp': FieldValue.serverTimestamp(),
                    'user_name': currentUserFirstName,
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