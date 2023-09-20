//import 'dart:ffi';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/model/product_model.dart';
import 'package:e_learning_app/screens/profile_screen.dart'; // Import your ProfileScreen
import 'package:e_learning_app/screens/home_screen_content.dart';
import 'package:e_learning_app/screens/Community_Screen.dart';
import 'package:flutter/material.dart';

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
    Text('Favorite Screen'),
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
      //body: _widgetOptions.elementAt(_selectedIndex),  // This line switches the content);
      body: SafeArea(
        child: ListView(
          children: [
            CustomeAppBar(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hi PraiseGod",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Vandag is 'n goeie dag om \n iets nuuts te leer!",
                            style: TextStyle(
                              color: Colors.black54,
                              wordSpacing: 2.5,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        mainAxisSize : MainAxisSize.min,
                        children: [
                          InkWell(
                          onTap : () async{
                            final newAvatarPrompt = (await showDialog<String>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Avatar Prompt'),
                                  content: Column(
                                    children: [
                                      DropdownButton(
                                          items: myAvatarTypes,
                                          value: "Avatar Type",
                                          onChanged: (String? newValue){
                                            setState(() {
                                              avatarPromptType = newValue!;

                                              if(newValue=="Robots"){
                                                avatarPromptTypeNumber = '1';
                                              }

                                              if(newValue=="Monsters"){
                                                avatarPromptTypeNumber = '2';
                                              }

                                              if(newValue=="Heads"){
                                                avatarPromptTypeNumber = '3';
                                              }

                                              if(newValue=="Kittens"){
                                                avatarPromptTypeNumber = '4';
                                              }

                                              if(newValue=="Humans"){
                                                avatarPromptTypeNumber = '5';
                                              }
                                              print(avatarPromptTypeNumber);
                                            });
                                          }),
                                      TextField(
                                        autofocus: true,
                                        decoration: InputDecoration(hintText: 'Enter an Avatar Prompt'),
                                        controller: controller,
                                      )
                                    ]
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: confirmPrompt,
                                        child: Text('Confirm'))
                                  ],
                                ),
                              ))!;
                            if(newAvatarPrompt == null || newAvatarPrompt.isEmpty)return;
                            setState(() => avatarPrompt=newAvatarPrompt);

                            print(avatarPrompt);
                            },
                            child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    color: kpurple,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Image.network(
                                  "https://robohash.org/$avatarPrompt?set=set$avatarPromptTypeNumber",
                                ),
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //sorting
                  Sorting(toggleGoalsOverlay: () {  }, showGoalsOverlay: null,),
                  const SizedBox(
                    height: 20,
                  ),
                  //category list

    ])
    )
    ])
    )
    );
  }

  void confirmPrompt(){
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }

}
