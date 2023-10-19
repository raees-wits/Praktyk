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
            if (widget.updateMode == "Modify") ...[
              Text('Select Category:'),
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                    isCreateCategorySelected = newValue == 'Create category';
                  });
                  if (!isCreateCategorySelected) {
                    fetchQuestionAnswers(dropdownValue!); // Fetch question-answer pairs when a category is selected
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
            ],
            // More conditions can be added here for other update modes
          ],
        ),
      ),
    );
  }
}