import 'package:e_learning_app/screens/Games/MemoryMatchSelectLevel.dart';
import 'package:e_learning_app/screens/Games/flappy_bird_game.dart';
import 'package:e_learning_app/screens/Games/memoryMatchScreen.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/constants.dart';
import 'hangman_screen.dart';
import 'fallingwordsgame_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({Key? key}) : super(key: key);

  Widget buildGradientButton({required VoidCallback onPressed, required String text, required List<Color> colors}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Game'),
        backgroundColor: kpurple,// Changed app bar title
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/games background.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildGradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FallingWordsGameScreen()),
                  );
                },
                text: 'Bubble Bananza',
                colors: [Colors.blue, Colors.purple],
              ),
              buildGradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HangmanGameScreen()),
                  );
                },
                text: 'Hangman',
                colors: [Colors.orange, Colors.red],
              ),
              buildGradientButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemoryMatchLevelSelect()),
                  );
                },
                text: 'Memory Match',
                colors: [Colors.yellow, Colors.orange],
              ),
              buildGradientButton(
                onPressed: () async {
                  var user = FirebaseAuth.instance.currentUser;

                  // Check if the user is not logged in. If not, bypass the Firebase check.
                  if (user == null) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FlappyBird()));
                    print("null user");
                  } else {
                    var userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);
                    var doc = await userRef.get();

                    if (!doc.exists || (doc.data() != null && !doc.data()!.containsKey('flappyBirdPlays')) || isNewDay(doc.data()?['lastPlayDate'])) {
                      await userRef.set({'flappyBirdPlays': 1, 'lastPlayDate': DateTime.now().toString()}, SetOptions(merge: true));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FlappyBird()));
                    } else {
                      var plays = doc.data()?['flappyBirdPlays'];
                      if (plays != null && plays < 5) {
                        await userRef.update({'flappyBirdPlays': plays + 1});
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FlappyBird()));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Limit Reached'),
                            content: Text('You have reached your daily limit of 5 plays for Flappy Bird.'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  }
                },
                text: 'Flappy Bird',
                colors: [Colors.purple, Colors.red],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  bool isNewDay(String lastPlayDate) {
    var lastDate = DateTime.parse(lastPlayDate);
    var currentDate = DateTime.now();
    return lastDate.day != currentDate.day || lastDate.month != currentDate.month || lastDate.year != currentDate.year;
  }
}
