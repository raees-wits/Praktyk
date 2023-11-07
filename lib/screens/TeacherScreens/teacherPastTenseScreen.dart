import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherPastTenseScreen extends StatefulWidget {
  @override
  _TeacherPastTenseScreenState createState() => _TeacherPastTenseScreenState();
}

class _TeacherPastTenseScreenState extends State<TeacherPastTenseScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, TextEditingController>> controllers = [];

  @override
  void dispose() {
    // Dispose of all the controllers when the widget is removed from the widget tree
    for (var controllerMap in controllers) {
      controllerMap['present']?.dispose();
      controllerMap['past']?.dispose();
    }
    super.dispose();
  }

  Widget _buildSaveButton(List<dynamic> questions) {
    return ElevatedButton(
      onPressed: () {
        var updatedQuestions = questions.asMap().entries.map((entry) {
          int idx = entry.key;
          var q = entry.value;
          q['Present Tense'] = controllers[idx]['present']!.text;
          q['Past Tense'] = controllers[idx]['past']!.text;
          return q;
        }).toList();

        // Update the Firestore document with new values
        _firestore.collection('Tenses').doc('Questions').set({'Questions': updatedQuestions});
      },
      child: Text('Save Changes'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tenses'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Tenses').doc('Questions').snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          var questions = data['Questions'] as List<dynamic>;
          controllers = []; // Reset controllers

          // Initialize a controller for each question
          for (var question in questions) {
            controllers.add({
              'present': TextEditingController(text: question['Present Tense']),
              'past': TextEditingController(text: question['Past Tense']),
            });
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    var question = questions[index];
                    return ListTile(
                      title: TextFormField(
                        controller: controllers[index]['present'],
                        decoration: InputDecoration(labelText: 'Present Tense'),
                      ),
                      subtitle: TextFormField(
                        controller: controllers[index]['past'],
                        decoration: InputDecoration(labelText: 'Past Tense'),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Delete the item
                          setState(() {
                            questions.removeAt(index);
                            controllers.removeAt(index);
                          });
                          // Update the Firestore document
                          _firestore.collection('Tenses').doc('Questions').update({'Questions': questions});
                        },
                      ),
                    );
                  },
                ),
                _buildSaveButton(questions),
              ],
            ),
          );
        },
      ),
    );
  }
}
