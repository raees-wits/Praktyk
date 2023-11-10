import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double barrierWidth; // out of 2, where 2 is the width of the screen
  final double barrierHeight; // proportion of the screen height
  final double barrierX;
  final bool isThisBottomBarrier;

  MyBarrier({
    required this.barrierHeight,
    required this.barrierWidth,
    required this.isThisBottomBarrier,
    required this.barrierX,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isThisBottomBarrier ? 1 : -1),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green[800], // Dark green color
              border: Border.all(
                color: Colors.green[900]!, // even darker green color for the border
                width: 10, // border width
              ),
            ),
            width: MediaQuery.of(context).size.width * barrierWidth / 2,
            height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
          ),
          Positioned(
            top: isThisBottomBarrier ? null : 0, // if it's a top barrier, position at the top
            bottom: isThisBottomBarrier ? 0 : null, // if it's a bottom barrier, position at the bottom
            child: Container(
              color: Colors.green[900], // even darker green color for the lip
              width: MediaQuery.of(context).size.width * barrierWidth / 2,
              height: 10, // height of the lip at the end of the barrier
            ),
          ),
        ],
      ),
    );
  }
}
