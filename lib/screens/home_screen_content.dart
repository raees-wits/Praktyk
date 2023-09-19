import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/model/product_model.dart';
import 'package:e_learning_app/screens/profile_screen.dart'; // Import your ProfileScreen
import 'components/appbar.dart';
import 'components/category.dart';
import 'components/sorting.dart';
import 'package:flutter/material.dart';

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: kpurple,
                              borderRadius: BorderRadius.circular(15.0)),
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
                Sorting(),
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
          )
        ],
      ),
    );
  }
}