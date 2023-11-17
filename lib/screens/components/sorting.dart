import 'package:e_learning_app/screens/achievements_page.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class Sorting extends StatelessWidget {
  final VoidCallback toggleGoalsOverlay;

  const Sorting({
    Key? key,
    required this.toggleGoalsOverlay, required showGoalsOverlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AchievementsPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: const Text(
                  "Milestones",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: toggleGoalsOverlay,
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
      ],
    );
  }
}
