import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/current_user.dart';

Future<int> fetchUserProgress(String userId, String category) async {
  final DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(userId)
      .get();

  if (!userDoc.exists) {
    return 0; // Return 0 if the user document doesn't exist
  }

  final Map<String, dynamic> questionsCompleted = userDoc['Questions Completed'];
  return questionsCompleted[category] ?? 0; // Return the user's progress for the category, defaulting to 0
}


Future<List<Map<String, String>>> fetchChallenges() async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Daily Challenges')
      .get();

  final List<Map<String, String>> challenges = querySnapshot.docs
      .map((doc) => {
    'Challenge': doc['Challenge'] as String,
    'Total': doc['Total'] as String,
    'Category': doc['Category'] as String,
  })
      .toList();

  return challenges;
}

class GoalsOverlayWidget extends StatefulWidget {
  final VoidCallback onClose;

  const GoalsOverlayWidget({Key? key, required this.onClose}) : super(key: key);

  @override
  _GoalsOverlayWidgetState createState() => _GoalsOverlayWidgetState();
}

class _GoalsOverlayWidgetState extends State<GoalsOverlayWidget> {
  late Future<List<Map<String, String>>> _challengesFuture;

  @override
  void initState() {
    super.initState();
    _challengesFuture = fetchChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: _challengesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No challenges available.');
        } else {
          final challenges = snapshot.data!;
          return Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white, // Background color of the overlay
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
                const Text(
                  'Daily Challenges',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                _buildChallengeWithProgress(challenges),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildChallengeWithProgress(List<Map<String, String>> challenges) {
    final selectedChallenges = challenges.take(3).toList();
    String userId = CurrentUser().userId!; // Assuming CurrentUser() is your user retrieval logic

    return Column(
      children: selectedChallenges.map((challenge) {
        return FutureBuilder<int>(
          future: fetchUserProgress(userId, challenge['Category']!),
          builder: (context, snapshot) {
            double progress = 0.0;
            if (snapshot.hasData) {
              int userProgress = snapshot.data!;
              int total = int.parse(challenge['Total'] ?? '0');
              progress = total > 0 ? userProgress / total : 0.0;
            }

            return Column(
              children: [
                ListTile(
                  leading: Icon(Icons.check_circle),
                  title: Text(challenge['Challenge'] ?? ''),
                  //subtitle: Text('Total: ${challenge['Total']}, Category: ${challenge['Category']}'),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: 8.0,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            );
          },
        );
      }).toList(),
    );
  }


}
