import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherNegativeFormScreen extends StatefulWidget {
  @override
  _TeacherNegativeFormScreenState createState() =>
      _TeacherNegativeFormScreenState();
}

class _TeacherNegativeFormScreenState extends State<TeacherNegativeFormScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> questionForms = [];

  void addNewQuestionForm() {
    setState(() {
      questionForms.add({
        'question': TextEditingController(text: ''),
        'answers': <TextEditingController>[TextEditingController(text: '')],
      });
    });
  }

  void addNewAnswerField(int questionIndex) {
    setState(() {
      questionForms[questionIndex]['answers'].add(TextEditingController(text: ''));
    });
  }

  @override
  void dispose() {
    // Dispose of all the controllers when the widget is removed from the widget tree
    for (var questionForm in questionForms) {
      questionForm['question'].dispose();
      for (TextEditingController answerCtrl in questionForm['answers']) {
        answerCtrl.dispose();
      }
    }
    super.dispose();
  }

  // Ensure this method returns a List<Widget> for the spread operator to work properly.
  List<Widget> _buildAnswerFields(int questionIndex) {
    List<Widget> answerFields = [];
    for (var answerController in questionForms[questionIndex]['answers']) {
      int answerIndex = questionForms[questionIndex]['answers'].indexOf(answerController);
      answerFields.add(
        TextFormField(
          controller: answerController,
          decoration: InputDecoration(
            labelText: 'Answer ${answerIndex + 1}',
            suffixIcon: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => removeAnswerField(questionIndex, answerIndex),
            ),
          ),
        ),
      );
    }
    return answerFields;
  }

  void removeAnswerField(int questionIndex, int answerIndex) {
    setState(() {
      questionForms[questionIndex]['answers'].removeAt(answerIndex);
    });
  }

  Future<void> saveToFirestore() async {
    try {
      List<Map<String, dynamic>> updatedForms = questionForms.map((questionForm) {
        List<String> answers = questionForm['answers']
            .map<String>((TextEditingController controller) => controller.text)
            .toList();
        return {
          'Question': questionForm['question'].text,
          'Answers': answers,
        };
      }).toList();

      await _firestore
          .collection('Negative Form')
          .doc('Questions')
          .set({'Questions': updatedForms});
    } catch (e) {
      print('Error saving to Firestore: $e');
      // Handle the error state here, if necessary
    }
  }

  // Update the delete question function to properly manage state and asynchronous calls
  void deleteQuestion(int index) async {
    // Remove the item from the list of question forms
    var removedQuestion = questionForms.removeAt(index);

    // Dispose of the text controllers to prevent memory leaks
    removedQuestion['question'].dispose();
    removedQuestion['answers'].forEach((controller) => controller.dispose());

    // Save the updated list to Firestore
    await saveToFirestore(); // Make sure to await this call

    // Then, if necessary, update the state to reflect the new list
    setState(() {});
  }

  Widget _buildFloatingActionButtons() {
    return Stack(
      children: [
        Positioned(
          right: 16.0,
          bottom: 80.0,
          child: FloatingActionButton(
            heroTag: 'addQuestion',
            onPressed: addNewQuestionForm,
            tooltip: 'Add Question',
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          ),
        ),
        Positioned(
          left: 16.0,
          bottom: 80.0,
          child: FloatingActionButton(
            heroTag: 'saveChanges',
            onPressed: saveToFirestore,
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
        title: Text('Edit Negative Forms'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Negative Form').doc('Questions').snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data?.data() as Map<String, dynamic>?;
          if (questionForms.isEmpty && data != null) {
            var forms = data['Questions'] ?? [];
            forms.forEach((form) {
              List<TextEditingController> answerControllers = List<TextEditingController>.from(
                (form['Answers'] as List<dynamic>).map((answer) => TextEditingController(text: answer)),
              );
              questionForms.add({
                'question': TextEditingController(text: form['Question']),
                'answers': answerControllers,
              });
            });
          }

          return SingleChildScrollView(
            child: Column(
              children: questionForms.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> form = entry.value;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: form['question'],
                        decoration: InputDecoration(labelText: 'Question'),
                      ),
                      ..._buildAnswerFields(index),
                      ElevatedButton(
                        onPressed: () => addNewAnswerField(index),
                        child: Text('Add Answer'),
                      ),
                      ElevatedButton(
                        onPressed: () => deleteQuestion(index),
                        child: Text('Delete Question'),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      ),
                      Divider(),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }
}
