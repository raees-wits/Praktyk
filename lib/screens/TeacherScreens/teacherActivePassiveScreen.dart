import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherActivePassiveScreen extends StatefulWidget {
  @override
  _TeacherActivePassiveScreenState createState() => _TeacherActivePassiveScreenState();
}

class _TeacherActivePassiveScreenState extends State<TeacherActivePassiveScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, TextEditingController>> controllers = [];

  void addNewTenseField() {
    setState(() {
      controllers.add({
        'Active': TextEditingController(text: ''),
        'Passive': TextEditingController(text: ''),
      });
    });
  }

  @override
  void dispose() {
    for (var controllerMap in controllers) {
      controllerMap['Active']?.dispose();
      controllerMap['Passive']?.dispose();
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
              DocumentSnapshot snapshot = await _firestore.collection('Active-Passive').doc('Questions').get();
              List currentQuestions = (snapshot.data() as Map<String, dynamic>)['Questions'] ?? [];

              List updatedQuestions = List.generate(currentQuestions.length, (index) {
                Map<String, dynamic> question = Map.from(currentQuestions[index]);
                if (index < controllers.length) {
                  question['Active'] = controllers[index]['Active']!.text;
                  question['Passive'] = controllers[index]['Passive']!.text;
                }
                return question;
              });

              if (controllers.length > currentQuestions.length) {
                updatedQuestions.addAll(
                  controllers.getRange(currentQuestions.length, controllers.length).map((controllerMap) {
                    return {
                      'Active': controllerMap['Active']!.text,
                      'Passive': controllerMap['Passive']!.text,
                    };
                  }).toList(),
                );
              }

              await _firestore.collection('Active-Passive').doc('Questions').set({'Questions': updatedQuestions});

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Question successfully submitted'),
                  duration: Duration(seconds: 2),
                ),
              );
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
        title: Text('Edit Active and Passive Form Questions'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Active-Passive').doc('Questions').snapshots(),
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
                'Active': TextEditingController(text: question['Active']),
                'Passive': TextEditingController(text: question['Passive']),
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
                            controller: controller['Active'],
                            decoration: InputDecoration(labelText: 'Active Form'),
                          ),
                          TextFormField(
                            controller: controller['Passive'],
                            decoration: InputDecoration(labelText: 'Passive Form'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    controllers.removeAt(index);
                                  });

                                  DocumentSnapshot snapshot = await _firestore.collection('Active-Passive').doc('Questions').get();
                                  List currentQuestions = (snapshot.data() as Map<String, dynamic>)['Questions'] ?? [];
                                  if (currentQuestions.length > index) {
                                    currentQuestions.removeAt(index);
                                  }

                                  await _firestore.collection('Active-Passive').doc('Questions').set({'Questions': currentQuestions});
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
