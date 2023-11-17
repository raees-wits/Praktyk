import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {

  final birdY;
  final double birdWidth;
  final double birdHeight;

  MyBird({this.birdY, required this.birdWidth, required this.birdHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, birdY),
        child: Image.asset(
            'assets/images/flappy-bird.png',
          width: MediaQuery.of(context).size.height * birdWidth/2,
          height: MediaQuery.of(context).size.height * birdHeight/2,
          fit: BoxFit.fill,
        )
    );
  }
}