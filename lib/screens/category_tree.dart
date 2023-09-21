import 'package:e_learning_app/model/category_modal.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/screens/anki_card_screen.dart';

class CategoryTree extends StatelessWidget {
  final List<Category> categories; // List of all categories

  CategoryTree({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Colors.orange, // Add the orange background color here
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "All Categories",
              style: TextStyle(
                color: Colors.white, // Optional: Text color
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          Color bgColor = Colors.transparent;

          // This is a static score value for demonstration purposes
          int staticScore = 100;

          return InkWell(
            onTap: () {
              // Add your onTap logic here if needed
            },
            onHover: (isHovered) {
              if (isHovered) {
                // Set the background color when hovered
                bgColor = Colors.blue.withOpacity(0.1); // Adjust opacity
              } else {
                // Set the background color when not hovered
                bgColor = Colors.transparent;
              }
            },
            child: Container(
              color: bgColor, // Apply the background color to the container
              child: ListTile(
                contentPadding:
                    EdgeInsets.all(16), // Add padding to the ListTile
                leading: Container(
                  width: 48, // Adjust the width of the leading image
                  height: 48, // Adjust the height of the leading image
                  child: Center(
                    child: Image.asset(
                      category.icon,
                      width: 24, // Adjust the image size
                      height: 24, // Adjust the image size
                    ),
                  ),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  category.description,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Learn screen with the selected word
                        // You can replace LearnScreen with your desired screen.
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         LearnScreen(word: category.name),
                        //   ),
                        // );
                      },
                      child: Text("Learn"),
                    ),
                    SizedBox(width: 8), // Add some spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Anki card screen with the selected word
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AnkiCardScreen(word: category.name),
                          ),
                        );
                      },
                      child: Text("Practice"),
                    ),
                    SizedBox(
                        width: 8), // Add spacing between the buttons and score
                    Text(
                      "Score: $staticScore", // Display the user's score here
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
