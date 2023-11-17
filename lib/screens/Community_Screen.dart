import 'package:e_learning_app/constants.dart';
import 'package:flutter/material.dart';
import '../model/current_user.dart';
import 'components/Question.dart';
import 'components/question_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController questionController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Question> questions = [];
  File? imageFile;
  bool isUploading = false; // Add a state variable for upload status
  bool questionPosted =
      false; // Add a state variable for successful question posting
  bool postAnonymously = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final querySnapshot = await firestore.collection('questions').get();
    setState(() {
      questions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        String userName = data['userName'] ??
            'Anonymous'; // Retrieve the user's name or default to 'Anonymous'
        return Question(
          doc.id,
          data['text'],
          [],
          userName,
        );
      }).toList();
    });
  }

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  void clearUploadStatus() {
    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Page'),
        backgroundColor: korange,
      ),
      body: ListView(
        children: [
          if (CurrentUser().userType == 'Student')
            Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Text box for entering a question
                  TextFormField(
                    controller: questionController,
                    decoration: InputDecoration(
                      hintText: 'Write your question here...',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  CheckboxListTile(
                    title: Text('Post anonymously'),
                    value: postAnonymously,
                    onChanged: (bool? value) {
                      setState(() {
                        postAnonymously = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  // Button to submit the question
                  ElevatedButton(
                    onPressed: () async {
                      String enteredQuestion = questionController.text;
                      if (enteredQuestion.isNotEmpty) {
                        setState(() {
                          isUploading = true;
                          questionPosted = false;
                        });

                        if (imageFile != null) {
                          final String fileName =
                              DateTime.now().millisecondsSinceEpoch.toString() +
                                  '.jpg';
                          final Reference storageRef = FirebaseStorage.instance
                              .ref()
                              .child('images/$fileName');
                          final UploadTask uploadTask =
                              storageRef.putFile(imageFile!);

                          try {
                            final TaskSnapshot snapshot =
                                await uploadTask.whenComplete(() => null);
                            final String imageUrl =
                                await snapshot.ref.getDownloadURL();

                            Map<String, dynamic> questionData = {
                              'text': enteredQuestion,
                              'timestamp': FieldValue.serverTimestamp(),
                              'imageUrl': imageUrl,
                            };

                            if (!postAnonymously) {
                              questionData['userName'] = CurrentUser()
                                  .firstName; // Replace with actual user name retrieval logic
                            }

                            await firestore
                                .collection('questions')
                                .add(questionData);
                          } catch (error) {
                            print('Upload error: $error');
                          } finally {
                            clearUploadStatus();
                          }
                        } else {
                          Map<String, dynamic> questionData = {
                            'text': enteredQuestion,
                            'timestamp': FieldValue.serverTimestamp(),
                          };

                          if (!postAnonymously) {
                            questionData['userName'] = CurrentUser()
                                .firstName; // Replace with actual user name retrieval logic
                          }

                          await firestore
                              .collection('questions')
                              .add(questionData);
                        }

                        questionController.clear();
                        loadQuestions();
                        setState(() {
                          questionPosted = true;
                          isUploading = false;
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final imagePicker = ImagePicker();
                      final pickedImageFile = await imagePicker.pickImage(
                          source: ImageSource.gallery);

                      // Set the imageFile variable to the pickedImageFile
                      if (pickedImageFile != null) {
                        setState(() {
                          imageFile = File(pickedImageFile.path);
                        });
                      }
                    },
                    child: Text('Attach Image'),
                  ),
                  // Use a Stack to overlay loading indicator and message
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Show a loading indicator while uploading
                      if (isUploading) CircularProgressIndicator(),

                      // Show "question successfully posted" message when uploading is done
                      if (questionPosted) Text('Question successfully posted'),
                    ],
                  ),
                ],
              ),
            ),
          for (var question in questions)
            QuestionWidget(
              questionId: question
                  .id, // Use the ID of the question document as questionId
              questionText: question.question,
              askerName:
                  question.userName, // Pass the user's name to QuestionWidget
            ),
        ],
      ),
    );
  }
}
