import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> fetchChallenges() async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Daily Challenges')
      .get();

  final List<String> challenges = querySnapshot.docs
      .map((doc) => doc['Challenge'] as String)
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
  late Future<List<String>> _challengesFuture;

  @override
  void initState() {
    super.initState();
    _challengesFuture = fetchChallenges();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _challengesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Shows a loading indicator while fetching data
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No challenges available.');
        } else {
          final challenges = snapshot.data!;
          return Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
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

  Widget _buildChallengeWithProgress(List<String> challenges) {
    final selectedChallenges = challenges.take(3).toList();

    return Column(
      children: selectedChallenges.map((challengeTitle) {
        // Example fixed progress value
        final progress = 0.5;
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text(challengeTitle),
            ),
            // Spacing between challenge and progress bar
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
      }).toList(),
    );
  }

}
