import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

import '../model/anki_modal.dart';

class AnkiCardScreen extends StatefulWidget {
  final String category;

  AnkiCardScreen({required this.category});

  @override
  _AnkiCardScreenState createState() => _AnkiCardScreenState();
}

class _AnkiCardScreenState extends State<AnkiCardScreen> {
  late AudioPlayer audioPlayer;
  int currentIndex = 0;
  List<String> englishWords = [];
  List<String> afrikaansWords = [];
  List<String?> audioClipUrls = [];
  bool userEnteredAnswer = false;
  String nextText = "Next";

  Color backgroundColor = Colors.orange[100]!;
  Color buttonColor = Colors.green;
  Color textColor = Colors.white;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the category document
      final DocumentReference categoryReference =
          firestore.collection('Anki').doc(widget.category);

      // Fetch data from the document
      final DocumentSnapshot ankiCardsSnapshot = await categoryReference.get();

      if (ankiCardsSnapshot.exists) {
        // Extract data map from the document
        final Map<String, dynamic> data =
            ankiCardsSnapshot.data() as Map<String, dynamic>;

        // Initialize lists to store fetched data
        englishWords = [];
        afrikaansWords = [];
        audioClipUrls = []; // Change the type to accept null

        // Iterate over the data map to extract values
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            // Extract values from the nested map
            final afrikaansWord = value['${key}_afr'];
            final englishWord = value['${key}_eng'];

            // Construct the sound key dynamically based on available keys
            final soundKey = value.keys.firstWhere(
                (k) => k.startsWith('sound_$key'),
                orElse: () => '');

            final soundUrl = value[soundKey];

            // Add the fetched data to the lists
            afrikaansWords.add(afrikaansWord.toString());
            englishWords.add(englishWord.toString());
            audioClipUrls.add(soundUrl?.toString());
          }
        });

        // Update the state with fetched data
        setState(() {
          print('Afrikaans Words: $afrikaansWords');
          print('English Words: $englishWords');
          print('Audio Clip URLs: $audioClipUrls');
        });
      }
    } catch (error) {
      // Handle error
      print('Error fetching data: $error');
    }
  }

  void playAudio() async {
    if (audioClipUrls.isNotEmpty) {
      await audioPlayer.play(audioClipUrls[currentIndex]!);
    }
  }

  void showAnkiModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnkiModal(
          englishWord: englishWords[currentIndex],
          afrikaansWord: afrikaansWords[currentIndex],
          audioClipUrl: audioClipUrls[currentIndex],
          onConfirm: (String userResponse) async {
            // Handle the user's response
            print('User response: $userResponse');

            // Move to the next card
            setState(() {
              userEnteredAnswer =
                  true; // Set to true when the user enters an answer
              if (currentIndex < englishWords.length - 1) {
                //currentIndex++;
              } else {
                // Optionally, show a message or perform an action when all cards are done
              }
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // Release resources when the widget is disposed
    audioPlayer.dispose();
    super.dispose();
  }

  void moveToNextCard() {
    setState(() {
      userEnteredAnswer = false; // Reset to false when moving to the next card
      if (currentIndex < englishWords.length - 1) {
        currentIndex++;
        if (currentIndex == englishWords.length - 1) {
          nextText = "Done";
        }
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.purple[100],
      ),
      backgroundColor: backgroundColor, // Set the background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Type what you hear",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40.0),
              Column(
                children: [
                  if (!userEnteredAnswer) ...{
                    ElevatedButton(
                      onPressed: () {
                        playAudio();
                      },
                      child: Icon(
                        Icons.volume_up,
                        size: 48.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24.0),
                        primary: buttonColor,
                      ),
                    ),
                  },
                  if (userEnteredAnswer) ...{
                    SizedBox(height: 40.0),
                    Text(
                      'English: ${englishWords[currentIndex]}',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Afrikaans: ${afrikaansWords[currentIndex]}',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        playAudio();
                      },
                      child: Icon(
                        Icons.volume_up,
                        size: 48.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24.0),
                        primary: buttonColor, // Set button background color
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        moveToNextCard();
                      },
                      child: Text(nextText),
                      style: ElevatedButton.styleFrom(
                        primary: buttonColor, // Set button background color
                      ),
                    ),
                  },
                  if (!userEnteredAnswer) ...{
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        showAnkiModal();
                      },
                      child: Text("Enter your answer"),
                      style: ElevatedButton.styleFrom(
                        primary: buttonColor, // Set button background color
                      ),
                    ),
                  },
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
