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

  get data => null;

  @override
  void initState() {
    super.initState();
    print("initState triggered");
    _fetchUserProgress();
  }

  Future<void> _fetchUserProgress() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userId).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        Map<String, dynamic> matchTheColumnMap =
            userData["MatchTheColumn"] as Map<String, dynamic>;

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "All Categories",
              style: TextStyle(
                color: Colors.white,
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

          int score = category.progress * 10;

          return InkWell(
            onTap: () {},
            onHover: (isHovered) {
              if (isHovered) {
                bgColor = Colors.blue.withOpacity(0.1);
              } else {
                bgColor = Colors.transparent;
              }
            },
            child: Container(
              color: bgColor,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Image.asset(
                      category.icon,
                      width: 24,
                      height: 24,
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
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: category.progress / 10,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MatchTheColumnPage(
                                    categoryName: category.name),
                              ),
                            );
                          },
                          child: Text("Start"),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Score: $score",
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
