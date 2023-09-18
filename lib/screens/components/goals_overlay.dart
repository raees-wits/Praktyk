import 'package:flutter/material.dart';

class GoalsOverlayWidget extends StatelessWidget {
  final VoidCallback onClose;

  const GoalsOverlayWidget({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                onPressed: onClose,
              ),
            ],
          ),
          Text(
            'Daily Challenges',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          // Implement the UI for your daily challenges here
          // You can use ListTile, Card, or any widgets you prefer
          // For simplicity, we'll use a ListTile as an example
          _buildChallengeWithProgress('Challenge 1', 0.5), // Example with 50% progress
          _buildChallengeWithProgress('Challenge 2', 0.2), // Example with 20% progress
          _buildChallengeWithProgress('Challenge 3', 0.8), // Example with 80% progress
          // Add more daily challenges as needed
        ],
      ),
    );
  }

  Widget _buildChallengeWithProgress(String challengeTitle, double progress) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.check_circle),
          title: Text(challengeTitle),
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
  }
}
