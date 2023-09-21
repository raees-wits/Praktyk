import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/model/product_model.dart';
import 'package:e_learning_app/screens/profile_screen.dart'; // Import your ProfileScreen
import 'components/appbar.dart';
import 'components/category.dart';
import 'components/goals_overlay.dart';
import 'components/sorting.dart';
import 'package:flutter/material.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: kpurple,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Image.asset(
                                "assets/images/profile.png",
                              ),
                            ),
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
              color: Colors.black.withOpacity(0.5), // Semi-transparent black background
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9, // Adjust the width as needed
                  heightFactor: 0.9, // Adjust the height as needed
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
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