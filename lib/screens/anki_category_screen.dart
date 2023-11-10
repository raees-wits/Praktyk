import 'package:e_learning_app/screens/anki_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'anki_update_screen.dart';

class AnkiCategoryScreen extends StatefulWidget {
  @override
  _AnkiCategoryScreenState createState() => _AnkiCategoryScreenState();
}

class _AnkiCategoryScreenState extends State<AnkiCategoryScreen> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list of categories by fetching subfolders from Firebase Storage
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    // Initialize Firebase Storage instance
    final FirebaseStorage storage = FirebaseStorage.instance;

    // Reference to the root folder
    final Reference rootReference = storage.ref('gs://praktyk-cb1c1.appspot.com/Audio');

    // List the items (subfolders) under the root folder
    final ListResult result = await rootReference.list();

    // Extract the subfolder names and update the state with just the category names
    setState(() {
      categories = result.prefixes.map((prefix) {
        final parts = prefix.fullPath.split('/');
        return parts.isNotEmpty ? parts.last : '';
      }).toList();
    });

    // Log the list of categories to the console
    //print("Categories: $categories");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a Category"),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 5,
            color: Colors.red[200], // Set the card color
            child: ListTile(
              title: Text(
                category,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set the text color
                ),
              ),
              onTap: () {
                // Navigate to the selected category
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnkiCardScreen(category: category),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


class AnkiUpdateScreen extends StatelessWidget {
  final String category;

  AnkiUpdateScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      // Display the details of the selected category here
    );
  }
}