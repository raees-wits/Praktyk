import 'package:flutter/material.dart';
import 'anki_card_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  try {
    final FirebaseStorage storage = FirebaseStorage.instance;

    // Reference to the 'Audio' folder in Firebase Storage
    final Reference audioReference = storage.ref('Audio');

    // List items in the 'Audio' folder
    final ListResult result = await audioReference.list();

   

    // Extract folder (category) names from the list
    final List<String> categoryNames = result.prefixes.map((prefix) => prefix.name).toList();

    setState(() {
      categories = categoryNames;
    });

    // Output category names to logs
   
  } catch (error) {
    print('Error fetching categories: $error');
  }
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
