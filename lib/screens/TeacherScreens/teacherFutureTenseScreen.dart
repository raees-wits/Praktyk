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
        title: Text('Edit Future Tenses'),
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
          if (controllers.isEmpty) {
            var questions = data?['Questions'] ?? [];
            for (var question in questions) {
              controllers.add({
                'present': TextEditingController(text: question['Present Tense']),
                'future': TextEditingController(text: question['Future Tense']),
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
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0), // Add top padding for spacing
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
                        children: [
                          TextFormField(
                            controller: controllers[index]['present'],
                            decoration: InputDecoration(labelText: 'Present Tense'),
                          ),
                          TextFormField(
                            controller: controllers[index]['future'],
                            decoration: InputDecoration(labelText: 'Future Tense'),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0), // Add more spacing if needed
                              child: SizedBox(
                                width: 150.0, // Set this to your desired width
                                child: ElevatedButton(
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
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(primary: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }
}
