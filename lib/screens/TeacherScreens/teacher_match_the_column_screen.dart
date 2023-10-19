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
  final categoryController = TextEditingController(); // Controller for the new category input
  final List<String> categories = [' ', 'Create category']; // Added blank option and "Create category"
  bool isCreateCategorySelected = false; // New state variable for visibility control
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
    // Validation: both question and answer fields must not be empty.
    if (dropdownValue == null || dropdownValue!.trim().isEmpty || questionController.text.trim().isEmpty || answerController.text.trim().isEmpty) {
      print("Please fill in all fields before submitting.");
      return;
    }

    // Prepare data for submission
    Map<String, dynamic> questionMap = {
      'Question': questionController.text,
      'Answer': answerController.text,
    };

    String finalCategory = dropdownValue!; // Assume an existing category is selected initially

    // If "Create category" is selected, use the new category input field's value
    if (isCreateCategorySelected) {
      finalCategory = categoryController.text; // New category name from the input field

      // Validate the new category name
      if (finalCategory.trim().isEmpty || categories.contains(finalCategory)) {
        print("Please enter a valid new category.");
        return;
      }

      categories.add(finalCategory); // Add the new category to the local categories list
    }

    // Reference to the Firestore document
    DocumentReference docRef = FirebaseFirestore.instance.collection('Match The Column').doc(finalCategory);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        // If the document doesn't exist (new category), create a new one with the initial question
        transaction.set(docRef, {'Questions': [questionMap]});
      } else {
        // If the document exists, append the new question to the 'Questions' array
        List<dynamic> questions = snapshot.get('Questions') as List<dynamic>;
        questions.add(questionMap);

        // Perform the update
        transaction.update(docRef, {'Questions': questions});
      }
    }).then((value) {
      print("Question Added");
      // Clear the text fields
      questionController.clear();
      answerController.clear();
      categoryController.clear(); // Don't forget to clear the new category field
      isCreateCategorySelected = false; // Reset the flag for creating a new category

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question successfully submitted'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }).catchError((error) => print("Failed to add question: $error"));
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                    isCreateCategorySelected = newValue == 'Create category';
                  });
                },
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // Conditional rendering of the new category text field
              if (isCreateCategorySelected) ...[
                SizedBox(height: 20),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    hintText: 'Enter new category',
                  ),
                ),
              ],
              SizedBox(height: 20),
              Text('Question (Afrikaans):'),
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  hintText: 'Enter your question',
                ),
              ),
              SizedBox(height: 20),
              Text('Answer (English):'),
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: 'Enter the answer',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitQuestion,
                child: Text('Submit Question'),
              ),
            ],
            // More conditions can be added here for other update modes
          ],
        ),
      ),
    );
  }
}