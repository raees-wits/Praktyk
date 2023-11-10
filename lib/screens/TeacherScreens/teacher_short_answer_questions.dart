import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageShortAnswerScreen extends StatefulWidget {
  @override
  _ManageShortAnswerScreenState createState() => _ManageShortAnswerScreenState();
}

class _ManageShortAnswerScreenState extends State<ManageShortAnswerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedCategory;
  Map<String, TextEditingController> questionControllers = {};
  Map<String, TextEditingController> answerControllers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Short Answer Questions'),
      ),
      body: Column(
        children: [
          // Category selection dropdown
          DropdownButton<String>(
            hint: Text("Select a category"),
            value: selectedCategory,
            onChanged: (newValue) {
              setState(() {
                selectedCategory = newValue;
                _loadQuestions(); // Load questions when a category is selected.
              });
            },
            items: [], // Populate this with categories from Firestore.
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questionControllers.length,
              itemBuilder: (context, index) {
                String questionKey = questionControllers.keys.elementAt(index);
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: questionControllers[questionKey],
                        decoration: InputDecoration(labelText: 'Question'),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: answerControllers[questionKey],
                        decoration: InputDecoration(labelText: 'Answer'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Remove question logic
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addNewQuestionField,
            child: Text('Add New Question'),
          ),
          ElevatedButton(
            onPressed: _saveQuestions,
            child: Text('Save Questions'),
          ),
        ],
      ),
    );
  }

  void _loadQuestions() {
    // Implement question loading logic
  }

  void _addNewQuestionField() {
    // Implement UI changes and state update for adding a new question
  }

  Future<void> _saveQuestions() async {
    // Implement saving logic to Firestore
  }
}
