import 'package:flutter/material.dart';

class GoalsOverlayWidget extends StatelessWidget {
  const GoalsOverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white, // Background color of the overlay
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Challenge 1'),
          ),
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Challenge 2'),
          ),
          ListTile(
            leading: Icon(Icons.check_circle),
            title: Text('Challenge 3'),
          ),
          // Add more daily challenges as needed
        ],
      ),
    );
  }
}
