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

  Widget _buildFloatingActionButtons() {
    return Stack(
      children: [
        Positioned(
          right: 16.0,
          bottom: 80.0,
          child: FloatingActionButton(
            onPressed: addNewTenseField,
            tooltip: 'Add Tense',
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          ),
        ),
        Positioned(
          left: 16.0,
          bottom: 80.0,
          child: FloatingActionButton(
            onPressed: () async {
              // Get the current snapshot to merge with updates
              DocumentSnapshot snapshot = await _firestore.collection('Tenses').doc('Questions').get();
              List currentQuestions = (snapshot.data() as Map<String, dynamic>)['Questions'] ?? [];

              List updatedQuestions = List.generate(currentQuestions.length, (index) {
                Map<String, dynamic> question = Map.from(currentQuestions[index]);
                // Update only the fields that we have controllers for
                if (index < controllers.length) {
                  question['Present Tense'] = controllers[index]['present']!.text;
                  question['Future Tense'] = controllers[index]['future']!.text;
                }
                return question;
              });

              // If there are more controllers than existing questions, add the new ones
              if (controllers.length > currentQuestions.length) {
                updatedQuestions.addAll(
                  controllers.getRange(currentQuestions.length, controllers.length).map((controllerMap) {
                    return {
                      'Present Tense': controllerMap['present']!.text,
                      'Future Tense': controllerMap['future']!.text,
                    };
                  }).toList(),
                );
              }

              // Set the merged 'Questions' list to Firestore
              await _firestore.collection('Tenses').doc('Questions').set({'Questions': updatedQuestions});
            },
            tooltip: 'Save Changes',
            child: Icon(Icons.save),
          ),
        ),
      ],
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

          var data = snapshot.data?.data() as Map<String, dynamic>?;
          if (controllers.isEmpty && data != null) {
            var questions = data['Questions'] ?? [];
            for (var question in questions) {
              controllers.add({
                'present': TextEditingController(text: question['Present Tense']),
                'future': TextEditingController(text: question['Future Tense']),
              });
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: controllers.asMap().map((index, controller) {
                return MapEntry(
                  index,
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: controller['present'],
                            decoration: InputDecoration(labelText: 'Present Tense'),
                          ),
                          TextFormField(
                            controller: controller['future'],
                            decoration: InputDecoration(labelText: 'Future Tense'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  // Step 1: Remove controller locally
                                  setState(() {
                                    controllers.removeAt(index);
                                  });

                                  // Step 2: Update Firestore
                                  DocumentSnapshot snapshot = await _firestore.collection('Tenses').doc('Questions').get();
                                  List currentQuestions = (snapshot.data() as Map<String, dynamic>)['Questions'] ?? [];
                                  // Assuming the 'Questions' array in the database directly correlates to the controllers array.
                                  if (currentQuestions.length > index) {
                                    currentQuestions.removeAt(index);
                                  }

                                  // Save the updated list back to Firestore.
                                  await _firestore.collection('Tenses').doc('Questions').set({'Questions': currentQuestions});
                                },
                                child: Text('Delete Question'),
                                style: ElevatedButton.styleFrom(primary: Colors.red),
                              ),

                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              }).values.toList(),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

}
