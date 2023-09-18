import 'package:flutter/material.dart';
import '../../constants.dart';
import 'goals_overlay.dart'; // Import the GoalsOverlayWidget

class Sorting extends StatelessWidget {
  final VoidCallback toggleGoalsOverlay;

  const Sorting({
    Key? key,
    required this.toggleGoalsOverlay, required showGoalsOverlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack( // Wrap everything in a Stack
      children: [
        Row(
          // Space between widgets
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              decoration: BoxDecoration(
                color: kpink,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                "Top",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: const Text(
                "Progress",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: toggleGoalsOverlay, // Use the provided callback to toggle the overlay
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: const Text(
                  "Goals",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                height: 20,
                child: Image.asset("assets/icon/treasure.png"),
              ),
            ),
          ],
        ),
        // Show the overlay when showGoalsOverlay is true
      ],
    );
  }
}
