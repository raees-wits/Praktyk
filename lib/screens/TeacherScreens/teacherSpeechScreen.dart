import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherSpeechScreen extends StatefulWidget {
  @override
  _TeacherSpeechScreenState createState() => _TeacherSpeechScreenState();
}

class _TeacherSpeechScreenState extends State<TeacherSpeechScreen> {
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
      questionForms[questionIndex]['answers']
          .add(TextEditingController(text: ''));
    });
  }

  @override
  void dispose() {
    for (var questionForm in questionForms) {
      questionForm['question'].dispose();
      for (TextEditingController answerCtrl in questionForm['answers']) {
        answerCtrl.dispose();
      }
    }
    super.dispose();
  }

  List<Widget> _buildAnswerFields(int questionIndex) {
    List<Widget> answerFields = [];
    for (var answerController in questionForms[questionIndex]['answers']) {
      int answerIndex = questionForms[questionIndex]['answers']
          .indexOf(answerController);
      answerFields.add(
        TextFormField(
          controller: answerController,
          decoration: InputDecoration(
            labelText: 'Indirect Speech Option ${answerIndex + 1}',
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
      List<Map<String, dynamic>> updatedForms = questionForms.map((
          questionForm) {
        List<String> answers = questionForm['answers']
            .map<String>((TextEditingController controller) => controller.text)
            .toList();
        return {
          'Question': questionForm['question'].text,
          'Answers': answers,
        };
      }).toList();

      await _firestore
          .collection('Indirect Speech')
          .doc('Questions')
          .set({'Questions': updatedForms});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question successfully submitted'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  void deleteQuestion(int index) async {
    var removedQuestion = questionForms.removeAt(index);
    removedQuestion['question'].dispose();
    removedQuestion['answers'].forEach((controller) => controller.dispose());
    await saveToFirestore();
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
        title: Text('Edit Indirect Speech'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('Indirect Speech')
            .doc('Questions')
            .snapshots(),
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
              List<TextEditingController> answerControllers =
              (form['Answers'] as List<dynamic>)
                  .map((answer) => TextEditingController(text: answer))
                  .toList();
              questionForms.add({
                'question': TextEditingController(text: form['Question']),
                'answers': answerControllers,
              });
            });
          }

          return SingleChildScrollView(
            child: Column(
              children: questionForms
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                Map<String, dynamic> form = entry.value;

                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: form['question'],
                          decoration: InputDecoration(labelText: 'Direct Speech'),
                        ),
                        ..._buildAnswerFields(index),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => addNewAnswerField(index),
                              child: Text('Add Indirect Speech Option'),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () => deleteQuestion(index),
                              child: Text('Delete Question'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
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
