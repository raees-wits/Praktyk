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

  //For the Modify section
  List<Map<String, dynamic>> questionAnswerPairs = []; // New variable to store question-answer pairs
  bool isEditing = false; // State to determine if a user is editing a question-answer pair

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

    // New validation: If creating a new category, ensure the category name is provided.
    if (isCreateCategorySelected && categoryController.text.trim().isEmpty) {
      print("Please provide a name for the new category.");
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
      finalCategory = categoryController.text.trim(); // Use trimmed value to avoid leading/trailing whitespaces

      // Ensure the new category name doesn't already exist
      if (categories.contains(finalCategory)) {
        print("This category already exists. Please enter a different name.");
        return;
      }

      categories.add(finalCategory); // Add the new category to the local list
      dropdownValue = finalCategory; // Update the dropdown to the new category
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

  void fetchQuestionAnswers(String category) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('Match The Column')
        .doc(category)
        .get();

    List<dynamic> questions = docSnapshot.get('Questions');
    setState(() {
      questionAnswerPairs = List<Map<String, dynamic>>.from(questions);
      isEditing = true; // Enable editing mode when question-answer pairs are fetched
    });
  }

  void updateQuestionAnswers(String category) async {
    // Perform the update in Firestore
    await FirebaseFirestore.instance
        .collection('Match The Column')
        .doc(category)
        .update({'Questions': questionAnswerPairs});

    setState(() {
      isEditing = false; // Disable editing mode after update
    });

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Updates successfully submitted'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  // Function to delete a question-answer pair
  void deleteQuestionAnswer(String category, int index) async {
    // Remove the pair from the local list
    setState(() {
      questionAnswerPairs.removeAt(index);
    });

    // Update the document in Firestore
    await FirebaseFirestore.instance
        .collection('Match The Column')
        .doc(category)
        .update({'Questions': questionAnswerPairs});

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Question-answer pair deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    questionController.dispose();
    answerController.dispose();
    categoryController.dispose(); // Ensure to dispose of this controller too
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
              Text('Select Category:'),
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    isCreateCategorySelected = newValue == 'Create category';

                    // Clear previous questions when changing category or creating a new one
                    if (newValue == 'Create category' || (dropdownValue != newValue && newValue != null)) {
                      questionAnswerPairs.clear();
                      isEditing = false;
                    }
                  });

                  // Fetch question-answer pairs only for existing categories
                  if (!isCreateCategorySelected && newValue != null) {
                    fetchQuestionAnswers(newValue);
                  }
                },

                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (isEditing) ...[
                SizedBox(height: 20),
                // Using Table widget to create a table-like structure
                Expanded(
                  child: SingleChildScrollView(
                    child: Table(
                      // Adding border to the table
                      border: TableBorder.all(color: Colors.black),
                      // Defining column widths
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(0.5), // added column for delete button
                      },
                      // Table's children
                      children: [
                        /// Table Row for Headings
                        const TableRow(children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Question', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Answer', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding( // Placeholder for the delete column in the header
                            padding: EdgeInsets.all(8.0),
                            child: Text(''), // This could be an empty Text widget, or you could provide a header like "Actions"
                          ),
                        ]),

                        // Table Rows for Question-Answer Pairs
                        ...questionAnswerPairs.map((pair) {
                          int index = questionAnswerPairs.indexOf(pair);
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: TextEditingController(text: pair['Question']),
                                  decoration: InputDecoration(
                                    hintText: 'Question (Afrikaans)',
                                    border: OutlineInputBorder(), // added border
                                  ),
                                  onChanged: (value) {
                                    pair['Question'] = value; // Update the question text in the pair
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: TextEditingController(text: pair['Answer']),
                                  decoration: InputDecoration(
                                    hintText: 'Answer (English)',
                                    border: OutlineInputBorder(), // added border
                                  ),
                                  onChanged: (value) {
                                    pair['Answer'] = value; // Update the answer text in the pair
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => deleteQuestionAnswer(dropdownValue!, index),
                                  color: Colors.red,
                                ),
                              ),
                            ]);
                        }).toList(),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: questionController, // Controller for new question input
                              decoration: InputDecoration(
                                hintText: 'New Question (Afrikaans)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: answerController, // Controller for new answer input
                              decoration: InputDecoration(
                                hintText: 'New Answer (English)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.add), // Change icon to "add"
                              onPressed: () {
                                // Functionality to add a new question-answer pair
                                if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                                  setState(() {
                                    questionAnswerPairs.add({
                                      'Question': questionController.text,
                                      'Answer': answerController.text,
                                    });
                                    // Optionally clear the input fields after adding
                                    questionController.clear();
                                    answerController.clear();
                                  });
                                  // Add to the database (if needed right away) or you can do it when 'Submit Updates' is pressed
                                  updateQuestionAnswers(dropdownValue!);
                                } else {
                                  print("Both fields must be filled!");
                                }
                              },
                              color: Colors.green, // Change button color to indicate a different action (add)
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => updateQuestionAnswers(dropdownValue!),
                  child: Text('Submit Updates'),
                ),
              ],
            // More conditions can be added here for other update modes
            // Condition to check if 'Create category' is selected, if so, show the input fields for new category, question, and answer.
            if (isCreateCategorySelected) ...[
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'New Category Name', // to indicate the purpose of the text field
                  hintText: 'Enter new category name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8), // for some spacing between the fields
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  labelText: 'New Question (Afrikaans)',
                  hintText: 'Enter new question',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8), // spacing between the fields
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  labelText: 'New Answer (English',
                  hintText: 'Enter new answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16), // spacing before the button
              ElevatedButton(
                onPressed: () => submitQuestion(), // this function should handle new category creation and question submission
                child: Text('Submit New Category and Question'),
              ),
            ]
          ],

        ),
      ),
    );
  }
}