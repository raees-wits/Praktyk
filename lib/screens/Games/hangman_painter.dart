import 'dart:ui';

import 'package:flutter/material.dart';

class HangmanPainter extends CustomPainter {
  final bool body, leftArm, rightArm, leftLeg, rightLeg, head;

  HangmanPainter({
    this.body = false,
    this.leftArm = false,
    this.rightArm = false,
    this.leftLeg = false,
    this.rightLeg = false,
    this.head = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.black;

    final postPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.black;

    // Draw the hangman post
    canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(400, 500),
          Offset(100, 500),
          Offset(150, 500),
          Offset(150, 100),
          Offset(320, 100),
          Offset(320, 150)
        ],
        postPaint);

    if (body) {
      // Draw the body
      canvas.drawLine(Offset(320, 230), Offset(320, 360), paint);
    }

    if (leftArm) {
      // Draw the left arm
      canvas.drawLine(Offset(320, 260), Offset(250, 230), paint);
    }

    if (rightArm) {
      // Draw the right arm
      canvas.drawLine(Offset(320, 260), Offset(390, 230), paint);
    }

    if (leftLeg) {
      // Draw the left leg
      canvas.drawLine(Offset(320, 360), Offset(250, 450), paint);
    }

    if (rightLeg) {
      // Draw the right leg
      canvas.drawLine(Offset(320, 360), Offset(390, 450), paint);
    }

    if (head) {
      // Draw the head
      canvas.drawCircle(Offset(320, 190), 40, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
