import 'package:e_learning_app/model/category_modal.dart';
import 'package:flutter/material.dart';
import 'package:e_learning_app/screens/anki_card_screen.dart';
import '../model/current_user.dart';
import 'components/MatchTheColumn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryTree extends StatefulWidget {
  final List<Category> categories;

  CategoryTree({Key? key, required this.categories}) : super(key: key);

  @override
  _CategoryTreeState createState() => _CategoryTreeState();
}

class _CategoryTreeState extends State<CategoryTree> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = CurrentUser().userId!;

  get data => null; // Assuming CurrentUser is available in your imports

  @override
  void initState() {
    super.initState();
    print("initState triggered");
    _fetchUserProgress();
  }

  Future<void> _fetchUserProgress() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userId).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        Map<String, dynamic> matchTheColumnMap = userData["MatchTheColumn"] as Map<String, dynamic>;


        for (var entry in matchTheColumnMap.entries) {
          String categoryName = entry.key;
          int progressValue = entry.value;

          for (var category in widget.categories) {
            if (category.name == categoryName) {
              category.progress = progressValue;
              break;
            }
          }
        }


        setState(() {}); // Refresh the UI
      }
    } catch (e) {
      print("Error fetching user progress: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          //color: Colors.orange, // Add the orange background color here
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
          int score = category.progress * 10;


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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      category.description,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10), // Space between description and progress bar
                    LinearProgressIndicator(
                      value: category.progress / 10, // Convert the progress to a fraction
                      backgroundColor: Colors.grey[300], // Background color of the progress bar
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Foreground color of the progress bar
                    ),
                    SizedBox(height: 10), // Space between progress bar and buttons
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the MatchTheColumnPage
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    MatchTheColumnPage(categoryName: category.name),
                              ),
                            );
                          },
                          child: Text("Start"),
                        ),
                        SizedBox(width: 8), // Add some spacing between buttons and score
                        Text(
                          "Score: $score", // Display the user's score here
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
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