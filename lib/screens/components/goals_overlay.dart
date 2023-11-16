import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Print each challenge with its total and category
  for (var challenge in challenges) {
    print('Challenge: ${challenge['Challenge']}, Total: ${challenge['Total']}, Category: ${challenge['Category']}');
  }

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

    return Column(
      children: selectedChallenges.map((challenge) {
        final progress = 0.5; // Example fixed progress value
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text(challenge['Challenge'] ?? ''),
              subtitle: Text('Total: ${challenge['Total']}, Category: ${challenge['Category']}'),
            ),
            SizedBox(height: 8.0), // Add spacing between challenge and progress bar
            SizedBox(
              height: 8.0, // Set the height here to make it taller
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            SizedBox(height: 16.0), // Add spacing between challenges
          ],
        );
      }).toList(),
    );
  }

}
