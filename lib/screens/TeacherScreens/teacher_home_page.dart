import 'package:e_learning_app/screens/practise_vocab_screen.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/screens/Community_Screen.dart';
import 'package:e_learning_app/screens/profile_screen.dart';
import '../../model/current_user.dart';
import '../components/appbar.dart';
import '../components/category.dart';
import '../components/sorting.dart';
import '../home_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  late TextEditingController controller;

  @override
  void initState(){
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    TeacherChoiceScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: kpink,
              inactiveColor: Colors.grey[300]),
          BottomNavyBarItem(
            icon: Icon(Icons.message),
            title: Text('Community'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  void confirmPrompt(){
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}

class TeacherChoiceScreen extends StatelessWidget {

  Widget _buildTile(BuildContext context, String title, Color color, IconData icon, VoidCallback onTap) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.white),
            SizedBox(height: 20.0),
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
  Widget buildWelcomePanel(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      color: Colors.blue[100],
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi ${CurrentUser().firstName ?? 'User'}",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Vandag is 'n goeie dag om iets nuuts te leer!",
                  style: TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildWelcomePanel(context),
          SizedBox(height: 16.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: [
                _buildTile(
                    context,
                    "View Student Perspective",
                    Colors.blue,
                    Icons.visibility,
                        () {
                      print("View Student Perspective tapped");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                ),
                _buildTile(
                    context,
                    "Add/Modify Questions",
                    Colors.green,
                    Icons.edit,
                        () {
                      print("Add/Modify Questions tapped");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PracticeVocabularyScreen(updateMode: "Modify")),
                      );
                    }

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}