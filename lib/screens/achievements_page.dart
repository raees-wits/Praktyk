import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_learning_app/screens/home_screen.dart';

class AchievementsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Achievements'),
      ),
      body: FutureBuilder(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            // Handle the case where data is null
            return Center(child: Text('No data available'));
          } else {
            Map<String, dynamic> userData =
                snapshot.data as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TrophyBar(
                      trophyName: 'Match The Column A',
                      achieved: (userData['Questions Completed']
                                  ?['Match The Column'] ??
                              0) >
                          3,
                      level: 1,
                      trophyColor: Colors.yellow,
                      desc: "Complete 3 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Match The Column B',
                      achieved: (userData['Questions Completed']
                                  ?['Match The Column'] ??
                              0) >
                          9,
                      level: 2,
                      trophyColor: Colors.green,
                      desc: "Complete 15 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Fill In The blanks A',
                      achieved: (userData['Questions Completed']
                                  ?['Fill In The Blanks'] ??
                              0) >
                          3,
                      level: 3,
                      trophyColor: Colors.yellow,
                      desc: "Complete 3 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Fill In The Blanks B',
                      achieved: (userData['Questions Completed']
                                  ?['Fill In The Blanks'] ??
                              0) >
                          9,
                      level: 4,
                      trophyColor: Colors.green,
                      desc: "Complete 15 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Comprehension A',
                      achieved: (userData['Questions Completed']
                                  ?['Comprehension'] ??
                              0) >
                          3,
                      level: 4,
                      trophyColor: Colors.yellow,
                      desc: "Complete 3 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Comprehension B',
                      achieved: (userData['Questions Completed']
                                  ?['Comprehension'] ??
                              0) >
                          9,
                      level: 4,
                      trophyColor: Colors.green,
                      desc: "Complete 15 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Multiple Choice A',
                      achieved: (userData['Questions Completed']
                                  ?['Multiple Choice'] ??
                              0) >
                          3,
                      level: 4,
                      trophyColor: Colors.yellow,
                      desc: "Complete 3 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Multiple Choice B',
                      achieved: (userData['Questions Completed']
                                  ?['Multiple Choice'] ??
                              0) >
                          9,
                      level: 4,
                      trophyColor: Colors.green,
                      desc: "Complete 15 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Short Questions A',
                      achieved: (userData['Questions Completed']
                                  ?['Short Questions'] ??
                              0) >
                          3,
                      level: 4,
                      trophyColor: Colors.yellow,
                      desc: "Complete 3 questions",
                    ),
                    TrophyBar(
                      trophyName: 'Short Questions B',
                      achieved: (userData['Questions Completed']
                                  ?['Short Questions'] ??
                              0) >
                          9,
                      level: 4,
                      trophyColor: Colors.green,
                      desc: "Complete 15 questions",
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Get the current user's ID
          User? currentUser = _auth.currentUser;
          String? userUID = currentUser?.uid;

          if (userUID != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          } else {
            print('Current user not available');
          }
        },
        child: Icon(Icons.home),
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserData() async {
    // Get the current user's ID
    User? currentUser = _auth.currentUser;
    String? userUID = currentUser?.uid;

    if (userUID != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userUID).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print("the coco");
        return {};
      }
    } else {
      print('Current user not available');
      return {};
    }
  }
}

class TrophyBar extends StatelessWidget {
  final String trophyName;
  final int level;
  final bool achieved;
  final Color trophyColor;
  final String desc;

  TrophyBar({
    required this.trophyName,
    required this.level,
    required this.achieved,
    required this.trophyColor,
    required this.desc,
  });
  @override
  Widget build(BuildContext context) {
    Color barColor = achieved ? trophyColor : Colors.grey;

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trophyName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '$desc',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
