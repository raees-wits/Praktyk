import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherMatchTheColumn extends StatefulWidget {
  final String updateMode;

  // Constructor
  const TeacherMatchTheColumn({Key? key, required this.updateMode}) : super(key: key);

  @override
  _TeacherMatchTheColumnState createState() => _TeacherMatchTheColumnState();
}

class _TeacherMatchTheColumnState extends State<TeacherMatchTheColumn> {
  String? dropdownValue;
  final questionController = TextEditingController();
  final answerController = TextEditingController();
  final List<String> categories = [];
  bool isLoading = true; // Flag to check if data is still loading

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch the categories when the widget is initialized
  }

  Future<void> fetchCategories() async {
    // Fetch the category names from the 'Match The Column' collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Match The Column').get();
    final allData = querySnapshot.docs.map((doc) => doc.id).toList(); // Get document IDs as category names

    // Update the state with the fetched category names and assign the default dropdown value
    setState(() {
      categories.addAll(allData);
      dropdownValue = categories.isNotEmpty ? categories[0] : null;
      isLoading = false; // Set isLoading to false once data is fetched
    });
  }

  Future<void> submitQuestion() async {
    // Add a new document inside the category with the question and answer
    if (dropdownValue != null) {
      await FirebaseFirestore.instance.collection('Match The Column').doc(dropdownValue).collection('items').add({
        'question': questionController.text,
        'answer': answerController.text,
      });
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Match The Column'),
      ),
      body: isLoading // Check if data is still loading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if yes
          : Padding( // Otherwise, show the regular UI
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.updateMode == "Add") ...[
              Text('Select Category:'),
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: categories // Use categories list here, instead of hardcoded values
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20), // to add spacing
              Text('Question:'),
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  hintText: 'Enter your question',
                ),
              ),
              SizedBox(height: 20), // to add spacing
              Text('Answer:'),
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: 'Enter the answer',
                ),
              ),
              SizedBox(height: 20), // to add spacing
              ElevatedButton(
                onPressed: submitQuestion, // Call the submitQuestion method when the button is pressed
                child: Text('Submit Question'),
              ),
            ],
            // You can add "else" or "else if" statements for other "updateMode" conditions
          ],
        ),
      ),
    );
  }
}
