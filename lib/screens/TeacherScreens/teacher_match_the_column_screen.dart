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
  final categoryController = TextEditingController();
  final List<String> categories = [' ', 'Create category']; // Added blank option and "Create category"
  bool isCreateCategorySelected = false;
  bool isLoading = true;


  List<Map<String, dynamic>> questionAnswerPairs = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Match The Column').get();
    final allData = querySnapshot.docs.map((doc) => doc.id).toList();


    setState(() {
      categories.addAll(allData);
      dropdownValue = categories.isNotEmpty ? categories[0] : null;
      isLoading = false;
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

    Map<String, dynamic> questionMap = {
      'Question': questionController.text,
      'Answer': answerController.text,
    };

    String finalCategory = dropdownValue!; // Assume an existing category is selected initially


    if (isCreateCategorySelected) {
      finalCategory = categoryController.text.trim();

      // Ensure the new category name doesn't already exist
      if (categories.contains(finalCategory)) {
        print("This category already exists. Please enter a different name.");
        return;
      }

      categories.add(finalCategory); // Add the new category to the local list
      dropdownValue = finalCategory; // Update the dropdown to the new category
    }

    DocumentReference docRef = FirebaseFirestore.instance.collection('Match The Column').doc(finalCategory);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        transaction.set(docRef, {'Questions': [questionMap]});
      } else {
        List<dynamic> questions = snapshot.get('Questions') as List<dynamic>;
        questions.add(questionMap);

        transaction.update(docRef, {'Questions': questions});
      }
    }).then((value) {
      print("Question Added");
      // Clear the text fields
      questionController.clear();
      answerController.clear();
      categoryController.clear();
      isCreateCategorySelected = false;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question successfully submitted'),
          duration: Duration(seconds: 2),
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
      isEditing = true;
    });
  }

  void updateQuestionAnswers(String category) async {
    // Perform the update in Firestore
    await FirebaseFirestore.instance
        .collection('Match The Column')
        .doc(category)
        .update({'Questions': questionAnswerPairs});

    setState(() {
      isEditing = false;
    });


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Updates successfully submitted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to delete a question-answer pair
  void deleteQuestionAnswer(String category, int index) async {
    setState(() {
      questionAnswerPairs.removeAt(index);
    });

    await FirebaseFirestore.instance
        .collection('Match The Column')
        .doc(category)
        .update({'Questions': questionAnswerPairs});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Question-answer pair deleted successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    categoryController.dispose();
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

                Expanded(
                  child: SingleChildScrollView(
                    child: Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(0.5),
                      },
                      children: [
                        // Table Row for Headings
                        const TableRow(children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Question', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Answer', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(''),
                          ),
                        ]),

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
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    pair['Question'] = value;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: TextEditingController(text: pair['Answer']),
                                  decoration: InputDecoration(
                                    hintText: 'Answer (English)',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    pair['Answer'] = value;
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
                              controller: questionController,
                              decoration: InputDecoration(
                                hintText: 'New Question (Afrikaans)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: answerController,
                              decoration: InputDecoration(
                                hintText: 'New Answer (English)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                                  setState(() {
                                    questionAnswerPairs.add({
                                      'Question': questionController.text,
                                      'Answer': answerController.text,
                                    });
                                    questionController.clear();
                                    answerController.clear();
                                  });
                                  updateQuestionAnswers(dropdownValue!);
                                } else {
                                  print("Both fields must be filled!");
                                }
                              },
                              color: Colors.green,
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
            // Condition to check if 'Create category' is selected, if so, show the input fields for new category, question, and answer.
            if (isCreateCategorySelected) ...[
              TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'New Category Name',
                  hintText: 'Enter new category name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  labelText: 'New Question (Afrikaans)',
                  hintText: 'Enter new question',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  labelText: 'New Answer (English',
                  hintText: 'Enter new answer',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => submitQuestion(), 
                child: Text('Submit New Category and Question'),
              ),
            ]
          ],

        ),
      ),
    );
  }
}