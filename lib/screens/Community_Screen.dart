import 'package:flutter/material.dart';
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
  bool questionPosted = false; // Add a state variable for successful question posting

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
        return Question(
          doc.id, // Use the document ID as the unique ID
          data['text'],
          [], // You can add answers here if needed
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
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                // Button to submit the question
                ElevatedButton(
                  onPressed: () async {
                    // Handle question submission here
                    String enteredQuestion = questionController.text;
                    if (enteredQuestion.isNotEmpty) {
                      setState(() {
                        isUploading = true; // Set uploading status to true
                        questionPosted = false; // Reset questionPosted status
                      });

                      if (imageFile != null) {
                        final String fileName =
                            DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
                        final Reference storageRef =
                        FirebaseStorage.instance.ref().child('images/$fileName');
                        final UploadTask uploadTask = storageRef.putFile(imageFile!);

                        try {
                          // Wait for the image upload to complete
                          final TaskSnapshot snapshot =
                          await uploadTask.whenComplete(() => null);

                          // Get the download URL of the uploaded image
                          final String imageUrl =
                          await snapshot.ref.getDownloadURL();

                          // Now, you can save the image URL along with the question to Firestore
                          await firestore.collection('questions').add({
                            'text': enteredQuestion,
                            'timestamp': FieldValue.serverTimestamp(),
                            'imageUrl': imageUrl, // Save the image URL in Firestore
                          });

                          // Clear the text field after submitting
                          questionController.clear();
                          // Reload questions to reflect the newly added one
                          loadQuestions();
                          clearUploadStatus();
                          setState(() {
                            questionPosted = true; // Set questionPosted status to true
                          });
                        } catch (error) {
                          print('Upload error: $error');
                          clearUploadStatus();
                        }
                      } else {
                        // If no image was selected, just save the question without an image
                        await firestore.collection('questions').add({
                          'text': enteredQuestion,
                          'timestamp': FieldValue.serverTimestamp(),
                        });

                        // Clear the text field after submitting
                        questionController.clear();
                        // Reload questions to reflect the newly added one
                        loadQuestions();
                        clearUploadStatus();
                        setState(() {
                          questionPosted = true; // Set questionPosted status to true
                        });
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final imagePicker = ImagePicker();
                    final pickedImageFile =
                    await imagePicker.pickImage(source: ImageSource.gallery);

                    // Set the imageFile variable to the pickedImageFile
                    if (pickedImageFile != null) {
                      setState(() {
                        imageFile = File(pickedImageFile.path);
                      });
                    }
                  },
                  child: Text('Attach Image'),
                ),

                // Show a loading indicator while uploading
                if (isUploading) CircularProgressIndicator(),

                // Show "question successfully posted" message when uploading is done
                if (questionPosted) Text('Question successfully posted'),

                SizedBox(height: 16.0),
              ],
            ),
          ),
          for (var question in questions)
            QuestionWidget(
              questionId: question.id, // Use the ID of the question document as questionId
              questionText: question.question,
            ),
        ],
      ),
    );
  }
}
