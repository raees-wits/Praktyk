import 'package:flutter/material.dart';
import 'package:e_learning_app/screens//practise_vocab_screen.dart';
import 'package:e_learning_app/constants.dart';

import '../screens/TeacherScreens/teacher_choice_screen.dart';
import '../screens/category_tree.dart';
import 'category_modal.dart';
import 'current_user.dart';

class Product {
  final String image, title;
  final int id, courses;
  final Color color;
  final Function? onTap; // Add this line for the onTap property
  Product({
    required this.image,
    required this.title,
    required this.courses,
    required this.color,
    required this.id,
    this.onTap, // Add this line for the constructor
  });
}

List<Product> products = [
  Product(
    id: 1,
    title: "Practise Vocabulary",
    image: "assets/images/practisevocab.png",
    color: Color(0xFF71b8ff),
    courses: 4,
  ),
  Product(
    id: 2,
    title: "Grammar Rules",
    image: "assets/images/grammarules.png",
    color: Color(0xFFff6374),
    courses: 9,
  ),
  Product(
      id: 3,
      title: "Pronounciation",
      image: "assets/images/pronounciation.png",
      color: Color(0xFFffaa5b),
      courses: 15,
      onTap: (BuildContext context) {
        // Add the onTap functionality
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoryTree(
                    categories: categories,
                  )),
        );
      }),
  Product(
    id: 4,
    title: "Games",
    image: "assets/images/games.png",
    color: Color(0xFFBA68C8),
    courses: 4,
  ),
  Product(
    id: 5,
    title: "Comprehension Texts",
    image: "assets/images/book2.png",
    color: kgreen,
    courses: 3,
  ),
];
