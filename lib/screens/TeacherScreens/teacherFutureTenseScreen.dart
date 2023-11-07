import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherFutureTenseScreen extends StatefulWidget {
  @override
  _TeacherFutureTenseScreenState createState() => _TeacherFutureTenseScreenState();
}

class _TeacherFutureTenseScreenState extends State<TeacherFutureTenseScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, TextEditingController>> controllers = [];

  void addNewTenseField() {
    setState(() {
      controllers.add({
        'present': TextEditingController(text: ''),
        'future': TextEditingController(text: ''),
      });
    });
  }

  @override
  void dispose() {
    // Dispose of all the controllers when the widget is removed from the widget tree
    for (var controllerMap in controllers) {
      controllerMap['present']?.dispose();
      controllerMap['future']?.dispose();
    }
    super.dispose();
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        // Get the current snapshot to merge with updates
        DocumentSnapshot snapshot = await _firestore.collection('Tenses').doc('Questions').get();
        List currentQuestions = (snapshot.data() as Map<String, dynamic>)['Questions'] ?? [];

        List updatedQuestions = List.generate(currentQuestions.length, (index) {
          Map<String, dynamic> question = Map.from(currentQuestions[index]);
          // Update only the fields that we have controllers for
          if (index < controllers.length) {
            question['Present Tense'] = controllers[index]['present']!.text;
            question['Future Tense'] = controllers[index]['future']!.text; // Changed 'Past Tense' to 'Future Tense'
          }
          return question;
        });

        // If there are more controllers than existing questions, add the new ones
        if (controllers.length > currentQuestions.length) {
          updatedQuestions.addAll(
            controllers.getRange(currentQuestions.length, controllers.length).map((controllerMap) {
              return {
                'Present Tense': controllerMap['present']!.text,
                'Future Tense': controllerMap['future']!.text, // Changed 'Past Tense' to 'Future Tense'
              };
            }).toList(),
          );
        }

        // Set the merged 'Questions' list to Firestore
        await _firestore.collection('Tenses').doc('Questions').set({'Questions': updatedQuestions});
      },
      child: Text('Save Changes'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Future Tense'),
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

          // Check for data existence and if controllers need to be initialized
          var data = snapshot.data!.data() as Map<String, dynamic>?;
          if (controllers.isEmpty) { // Check this to avoid resetting controllers
            var questions = data?['Questions'] ?? [];
            for (var question in questions) {
              controllers.add({
                'present': TextEditingController(text: question['Present Tense']),
                'future': TextEditingController(text: question['Future Tense'] ?? ''), // Safely access the map
              });
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controllers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: TextFormField(
                        controller: controllers[index]['present'],
                        decoration: InputDecoration(labelText: 'Present Tense'),
                      ),
                      subtitle: TextFormField(
                        controller: controllers[index]['future'], // Changed 'past' to 'future'
                        decoration: InputDecoration(labelText: 'Future Tense'), // Changed 'Past Tense' to 'Future Tense'
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            if (index < data?['Questions'].length) {
                              // Update Firestore only if the question exists there
                              data?['Questions'].removeAt(index);
                              _firestore.collection('Tenses').doc('Questions').update({'Questions': data?['Questions']});
                            }
                            // Remove the controller regardless
                            controllers.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
                _buildSaveButton(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewTenseField,
        tooltip: 'Add Future Tense',
        child: Icon(Icons.add),
      ),
    );
  }
}
