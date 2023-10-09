//import 'dart:ffi';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/model/product_model.dart';
import 'package:e_learning_app/screens/profile_screen.dart'; // Import your ProfileScreen
import 'package:e_learning_app/screens/home_screen_content.dart';
import 'package:e_learning_app/screens/Community_Screen.dart';
import 'package:e_learning_app/screens/leaderboard_screen.dart';
import 'package:flutter/material.dart';
import 'components/MatchTheColumn.dart';

import 'components/appbar.dart';
import 'components/category.dart';
import 'components/sorting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  // Create a list of widgets to display conditionally based on the selected index
  final List<Widget> _widgetOptions = [
    // Your Home screen widget here
    HomeScreenContent(),
    //Text("Favourite Page"),
    LeaderBoardScreen(),
    CommunityScreen(),
    ProfileScreen(), // Your ProfileScreen widget here
  ];

  //Initialise Avatar properties
  String avatarPrompt = "Neo";
  String avatarPromptType = "Humans";
  String avatarPromptTypeNumber = '5';
  List<DropdownMenuItem<String>> myAvatarTypes = <String>["Robots","Monsters","Heads","Kittens","Humans"]
      .map<DropdownMenuItem<String>>((String value){
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottom bar
      // now we will use bottom bar package
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        showElevation: true, // use this to remove appBar's elevation
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
            icon: Icon(Icons.favorite_rounded),
            title: Text('Favorite'),
            inactiveColor: Colors.grey[300],
            activeColor: kpink,
          ),
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
      body: _widgetOptions.elementAt(_selectedIndex),  // This line switches the content);

    );
  }


  void confirmPrompt(){
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }

}
