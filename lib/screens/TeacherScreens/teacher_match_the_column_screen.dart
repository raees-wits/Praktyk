import 'package:flutter/material.dart';

class TeacherMatchTheColumn extends StatefulWidget {
  final String updateMode;

  // Constructor
  const TeacherMatchTheColumn({Key? key, required this.updateMode}) : super(key: key);

  @override
  _TeacherMatchTheColumnState createState() => _TeacherMatchTheColumnState();
}

class _TeacherMatchTheColumnState extends State<TeacherMatchTheColumn> {
  String dropdownValue = 'Category 1'; // Default value for the dropdown
  final questionController = TextEditingController();
  final answerController = TextEditingController();

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
      body: Padding(
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
                items: <String>['Category 1', 'Category 2', 'Category 3', 'Category 4']
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
                onPressed: () {
                  // TODO: Implement the submission logic
                  // For now, let's print the values to the console
                  print('Category: $dropdownValue');
                  print('Question: ${questionController.text}');
                  print('Answer: ${answerController.text}');
                },
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
