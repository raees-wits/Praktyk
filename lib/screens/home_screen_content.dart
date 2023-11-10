import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/model/product_model.dart';
import 'package:e_learning_app/screens/profile_screen.dart'; // Import your ProfileScreen
import 'components/appbar.dart';
import 'components/category.dart';
import 'components/goals_overlay.dart';
import 'components/sorting.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/model/current_user.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  String? userName;
  String? avatarPrompt;
  String? avatarPromptTypeNumber;
  String? tempAvatarPromptType;

  Future<void> fetchUserName() async {
    try {
      String userId = CurrentUser().userId!;
      print('User ID: $userId');
      var document = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      setState(() {
        userName = document.data()?['firstName'];
        avatarPrompt = document.data()?['avatarPrompt'];
        avatarPromptTypeNumber = document.data()?['avatarPromptTypeNumber'];
        tempAvatarPromptType = avatarPromptTypeNumber;
        print('Fetched username: $userName'); // Added this print statement
      });
    } catch (error) {
      print("Error fetching user name: $error");
    }
  }

  late TextEditingController controller; //For the avatar
  bool showGoalsOverlay = false; // Track whether the overlay should be shown

  void _toggleGoalsOverlay() {
    setState(() {
      showGoalsOverlay = !showGoalsOverlay;
    });
  }

  void _closeGoalsOverlay() {
    setState(() {
      showGoalsOverlay = false;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchUserName();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void confirmPrompt() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }

  //Initialise Avatar properties
  String avatarPromptType = "Humans";

  List<DropdownMenuItem<String>> myAvatarTypes = <String>[
    "Robots",
    "Monsters",
    "Heads",
    "Kittens",
    "Humans"
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem(
      child: Text(value),
      value: value,
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ListView(
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
                          children: [
                            Text(
                              "Welcome ${userName ?? ''} !",
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                                onTap: () async {
                                  final newAvatarPrompt =
                                      (await showDialog<String>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Avatar Prompt'),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            DropdownButton<String>(
                                                //items: myAvatarTypes,
                                                items: myAvatarTypes,
                                                value: avatarPromptType,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    avatarPromptType =
                                                        newValue!;
                                                    if (newValue == "Robots") {
                                                      avatarPromptTypeNumber =
                                                          '1';
                                                    }

                                                    if (newValue ==
                                                        "Monsters") {
                                                      avatarPromptTypeNumber =
                                                          '2';
                                                    }

                                                    if (newValue == "Heads") {
                                                      avatarPromptTypeNumber =
                                                          '3';
                                                    }

                                                    if (newValue == "Kittens") {
                                                      avatarPromptTypeNumber =
                                                          '4';
                                                    }

                                                    if (newValue == "Humans") {
                                                      avatarPromptTypeNumber =
                                                          '5';
                                                    }

                                                    print(avatarPromptType);
                                                  });
                                                }),
                                            TextField(
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      'Enter an Avatar Prompt'),
                                              controller: controller,
                                            )
                                          ]),
                                      actions: [
                                        TextButton(
                                            onPressed: confirmPrompt,
                                            child: Text('Confirm'))
                                      ],
                                    ),
                                  ))!;
                                  if (newAvatarPrompt == null ||
                                      newAvatarPrompt.isEmpty) return;
                                  setState(
                                      () => avatarPrompt = newAvatarPrompt);

                                  try {
                                    final userRef = FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(CurrentUser().userId!);
                                    await userRef.set({
                                      'avatarPrompt': avatarPrompt,
                                      "avatarPromptTypeNumber":
                                          avatarPromptTypeNumber
                                    }, SetOptions(merge: true));
                                  } catch (e) {
                                    print("Error updating avatar: $e");
                                  }

                                  print(avatarPrompt);
                                },
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: kpurple,
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: Image.network(
                                    "https://robohash.org/$avatarPrompt?set=set$avatarPromptTypeNumber",
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //sorting
                    Sorting(
                      showGoalsOverlay: showGoalsOverlay,
                      toggleGoalsOverlay: _toggleGoalsOverlay,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //category list

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            "See All",
                            style: TextStyle(fontSize: 16, color: kblue),
                          ),
                        ),
                      ],
                    ),

                    //now we create model of our images and colors which we will use in our app
                    const SizedBox(
                      height: 20,
                    ),
                    //we can not use gridview inside column
                    //use shrinkwrap and physical scroll
                    CategoryList(),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Show the overlay when showGoalsOverlay is true
          if (showGoalsOverlay)
            Container(
              color: Colors.black
                  .withOpacity(0.5), // Semi-transparent black background
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9, // Adjust the width as needed
                  heightFactor: 0.9, // Adjust the height as needed
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the radius as needed
                    child: Container(
                      color: Colors.white, // Background color of the overlay
                      child: GoalsOverlayWidget(
                        onClose: _closeGoalsOverlay, // Pass the close callback
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
