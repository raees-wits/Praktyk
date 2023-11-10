import 'package:e_learning_app/screens/Games/bird.dart';
import 'package:e_learning_app/screens/Games/flappy_bird_barrier.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FlappyBird extends StatefulWidget {
  const FlappyBird({Key? key}) : super(key: key);

  @override
  _FlappyBirdState createState() => _FlappyBirdState();
}

class _FlappyBirdState extends State<FlappyBird> {

  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3;
  double birdHeight = 0.09;
  double birdWidth = 0.09;

  //game settings
  bool gameHasStarted = false;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5, 2+3];
  static double barrierWidth = 0.5; // 0.5 out of 2
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the height of the entire screen
    [0.6, 0.7],
    [0.2, 1.0],
    [0.2, 0.7],
  ];

  // Scoring
  int score = 0;
  int bestScore = 0;

  @override
  void initState() {
    super.initState();
    loadBestScore();
  }

  void loadBestScore() {
    // Load the best score from persistent storage if available
    // For example, using SharedPreferences
    // bestScore = [load from storage]
  }

  void startGame() {
    gameHasStarted = true;
    score = 0;

    Timer.periodic(Duration(milliseconds: 50), (timer) {
      //real physics jump
      height = -4.9 * time * time + velocity * time;
      setState(() {
        birdY = initialPos - height;
      });

      //check if bird is dead
      if (birdIsDead()) {
        timer.cancel();
        gameHasStarted = false;
        _showDialog();
        // best score must be saved to database
      }
      else{
        setState(() {
          score++;
        });
        if (score > bestScore) {
          bestScore = score;
        }
      }

      moveMap();

      // time progression
      time += 0.03;
    });
  }

  void jump() {
    time = 0;
    initialPos = birdY;
  }

  void resetGame() {
    Navigator.pop(context); // Closes the dialog
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      // Reset barrier positions
      barrierX = [2, 2 + 1.5, 2+3]; // Reset to initial positions
      // Reset other game states if necessary
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    "PLAY AGAIN",
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool birdIsDead() {
    //check if bird is dead
    if (birdY < -1 || birdY > 1) {
      return true;
    }
    //check if bird is hitting barrier

    // checks if bird is within x coordinates and y coordinates of barriers
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] < birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      // keep barriers moving
      setState(() {
        barrierX[i] -= 0.025;
      });
      // if barrier exits the left part of the screen, keep it looping
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      MyBird(
                        birdY: birdY,
                        birdHeight: birdHeight,
                        birdWidth: birdWidth,
                      ),

                      // first barrier pair
                      MyBarrier(
                        barrierX: barrierX[0],
                        isThisBottomBarrier: false,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                      ),
                      MyBarrier(
                        barrierX: barrierX[0],
                        isThisBottomBarrier: true,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                      ),

                      //seocnd barrier pair
                      MyBarrier(
                        barrierX: barrierX[1],
                        isThisBottomBarrier: false,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                      ),
                      MyBarrier(
                        barrierX: barrierX[1],
                        isThisBottomBarrier: true,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                      ),
                      //3rd
                      MyBarrier(
                        barrierX: barrierX[2],
                        isThisBottomBarrier: false,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[2][0],
                      ),
                      MyBarrier(
                        barrierX: barrierX[2],
                        isThisBottomBarrier: true,
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[2][1],
                      ),

                      Container(
                          alignment: Alignment(0, -0.5),
                          child: Text(
                            gameHasStarted ? "" : 'T A P  T O  P L A Y',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ))
                    ],
                  ),
                ),
              ), // Container
            ),
            Container(
              color: Colors.green,
              height: 15,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 0,
                        ),
                        Text(
                          score.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "BEST",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: 0,
                        ),
                        Text(
                          bestScore.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ], // Column
        ), // Scaffold
      ),
    );
  }
}
