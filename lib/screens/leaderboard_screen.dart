import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/screens/home_screen.dart';

class LeaderBoardScreen extends StatefulWidget {
  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class Leader {
  final String winnerName;
  final String rank;
  final String rankInCircle;
  final String url;
  final String avatarPrompt;
  final String avatarPromptTypeNumber;

  Leader({
    required this.winnerName,
    required this.rank,
    required this.rankInCircle,
    required this.url,
    required this.avatarPrompt,
    required this.avatarPromptTypeNumber,
  });
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  List<Leader> first = [];
  List<Leader> second = [];
  List<Leader> third = [];
  List<Map<String, dynamic>> contestants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });

    queryLeaderboard();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> queryLeaderboard() async {
    try {
      CollectionReference leaderboardCollection =
          FirebaseFirestore.instance.collection('Users');

      QuerySnapshot querySnapshot = await leaderboardCollection
          .orderBy('Total Questions Answered', descending: true)
          .get();

      int count = 0;

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          String firstName = data['firstName'] ?? 'N/A';
          String grade = data['grade'] ?? 'N/A';
          String avatarPrompt = data['avatarPrompt'] ?? 'default';
          String avatarPromptTypeNumber = data['avatarPromptTypeNumber'] ?? '1';
          int totalQuestionsAnswered = data['Total Questions Answered'] ?? 0;
          totalQuestionsAnswered = totalQuestionsAnswered * 321;
          String stringValue = totalQuestionsAnswered.toString();

          if (count == 0) {
            first.add(Leader(
                winnerName: firstName,
                rank: stringValue,
                avatarPrompt: avatarPrompt,
                avatarPromptTypeNumber: avatarPromptTypeNumber,
                rankInCircle: '1',
                url: 'assets/images/games.png'));
          } else if (count == 1) {
            second.add(Leader(
                winnerName: firstName,
                rank: stringValue,
                avatarPrompt: avatarPrompt,
                avatarPromptTypeNumber: avatarPromptTypeNumber,
                rankInCircle: '2',
                url: 'assets/images/games.png'));
          } else if (count == 2) {
            third.add(Leader(
                winnerName: firstName,
                rank: stringValue,
                avatarPrompt: avatarPrompt,
                avatarPromptTypeNumber: avatarPromptTypeNumber,
                rankInCircle: '3',
                url: 'assets/images/games.png'));
          } else {
            contestants.add({
              'firstName': firstName,
              'grade': grade,
              'avatarPrompt': avatarPrompt,
              'rank': stringValue,
              'avatarPromptTypeNumber': avatarPromptTypeNumber
            });
          }

          count++;
        }
      }

      setState(() {});
    } catch (e) {
      // print('Error querying Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.red,
                ),
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
              actions: [
                Icon(
                  Icons.grid_view,
                  color: Colors.red,
                ),
              ],
            ),
            body: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.yellow.shade600,
                              Colors.orange,
                              Colors.red,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.black,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Regional',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Text(
                                    'National',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: WinnerContainer(
                                leader: first.isEmpty ? null : first[0],
                                color: Colors.green,
                              ),
                            ),
                            Expanded(
                              child: WinnerContainer(
                                leader: second.isEmpty ? null : second[0],
                                color: Colors.orange,
                              ),
                            ),
                            Expanded(
                              child: WinnerContainer(
                                leader: third.isEmpty ? null : third[0],
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.yellow.shade600,
                              Colors.black,
                              Colors.blue,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 360.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              color: Colors.purple,
                            ),
                            child: GridView.count(
                              crossAxisCount: 1,
                              childAspectRatio: 3.5,
                              children: [
                                for (var contestant in contestants)
                                  ContestantList(
                                    url:
                                        'https://robohash.org/${contestant['avatarPrompt']}?set=set${contestant['avatarPromptTypeNumber']}',
                                    firstName: contestant['firstName'],
                                    grade: contestant['grade'],
                                    rank: contestant['rank'],
                                    avatarPrompt: contestant['avatarPrompt'],
                                    avatarPromptTypeNumber:
                                        contestant['avatarPromptTypeNumber'],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class WinnerContainer extends StatelessWidget {
  final Leader? leader;
  final Color color;

  WinnerContainer({
    required this.leader,
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellow.shade600,
                      Colors.orange,
                      Colors.red,
                    ],
                  ),
                  border: Border.all(
                    color: Colors.amber,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    height: 150.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Stack(
              children: [
                if (leader != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 15.0),
                      child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.shade600,
                                Colors.orange,
                                Colors.red,
                              ],
                            ),
                            border: Border.all(
                              color: Colors.amber,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipOval(
                              clipBehavior: Clip.antiAlias,
                              child: leader != null
                                  //? Image.asset(
                                  //  leader!.url,
                                  ? Image.network(
                                      "https://robohash.org/${leader?.avatarPrompt}?set=set${leader?.avatarPromptTypeNumber}",
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 115.0, left: 45.0),
                  child: Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                    ),
                    child: Center(
                      child: Text(
                        //leader?.rank ?? '1',
                        leader?.rankInCircle ?? '1',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.2, // Adjust the percentage as needed
            left: MediaQuery.of(context).size.width *
                0.1, // Adjust the percentage as needed
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.1, // Adjust the width percentage as needed
              child: Center(
                child: Column(
                  children: [
                    Text(
                      leader?.winnerName ?? 'Emma',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      leader?.rank ?? '1',
                      style: TextStyle(
                        color: color,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContestantList extends StatelessWidget {
  final String firstName;
  final String grade;
  final String url;
  final String rank;
  final String avatarPrompt;
  final String avatarPromptTypeNumber;

  ContestantList(
      {required this.url,
      required this.firstName,
      required this.grade,
      required this.avatarPrompt,
      required this.rank,
      required this.avatarPromptTypeNumber});

  @override
  Widget build(BuildContext context) {
    final defaultColor = Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            defaultColor[400] ?? defaultColor,
            defaultColor,
            defaultColor[400] ?? defaultColor,
          ],
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              "https://robohash.org/$avatarPrompt?set=set$avatarPromptTypeNumber",
              height: 60.0,
              width: 60.0,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firstName ?? 'Name',
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Grade: $grade',
                    style: TextStyle(color: Colors.white54, fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'XP: $rank',
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.favorite,
                color: defaultColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
