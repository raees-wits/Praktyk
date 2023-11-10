import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnkiCardScreen extends StatefulWidget {
  final String category;

  AnkiCardScreen({required this.category});

  @override
  _AnkiCardScreenState createState() => _AnkiCardScreenState();
}

class _AnkiCardScreenState extends State<AnkiCardScreen> {
  String englishWord = "";
  String afrikaansWord = "";
  String audioClipUrl = "";
  int currentItemIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch data for the selected category from Firebase Storage or any other source.
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;

      // Reference to the category folder
      final Reference categoryReference = storage.ref('gs://praktyk-cb1c1.appspot.com/Audio/${widget.category}');
      // ...
      print("Storage Path: ${categoryReference.fullPath}");


      // Fetch data from CSV files
      final englishCsvData = await categoryReference.child('english.csv').getData();
      final afrikaansCsvData = await categoryReference.child('afrikaans.csv').getData();

      // Decode CSV data
      final englishCsvString = utf8.decode(englishCsvData!);
      final afrikaansCsvString = utf8.decode(afrikaansCsvData!);

      // Parse CSV data
      final englishTable = CsvToListConverter().convert(englishCsvString);
      final afrikaansTable = CsvToListConverter().convert(afrikaansCsvString);

      // Assuming the CSV structure is consistent, and the first row contains headers
      final englishPhrase = englishTable[1][0];
      final afrikaansPhrase = afrikaansTable[1][0];

      final audioClipUrl = 'gs://praktyk-cb1c1.appspot.com/Audio/${widget.category}/sound_${currentItemIndex + 1}.mp3';
      // Fetch data from Firebase Storage or any other data source
  // Replace the following with your actual data retrieval logic.
  final englishWordUrl = await categoryReference.child('englishWord.txt').getDownloadURL();
  final afrikaansWordUrl = await categoryReference.child('afrikaansWord.txt').getDownloadURL();
  //final audioClipUrl = await categoryReference.child('audio.mp3').getDownloadURL();
  print("Storage Path: ${categoryReference.fullPath}");
  print("English Word: $englishWordUrl");
  print("Afrikaans Word: $afrikaansWordUrl");
  print("Audio Clip URL: $audioClipUrl");



      // Update the state with fetched data
      setState(() {
        englishWord = englishPhrase;
        afrikaansWord = afrikaansPhrase;
        //audioClipUrl = audioClipUrl;
      });
    } catch (error) {
      print('Error fetching data: $error');
      print('its bugged');
      // Handle error (show a message to the user, retry, etc.)
    }
  }

  void navigateToNextItem() {
    // Increment the index to navigate to the next item
    currentItemIndex++;

    // Fetch data for the next item
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Center(
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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Play the audio clip from 'audioClipUrl'
                // Implement your audio playback logic here.
              },
              child: Icon(
                Icons.volume_up,
                size: 48.0,
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(24.0),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'English: $englishWord',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Afrikaans: $afrikaansWord',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next item in the category
                navigateToNextItem();
              },
              child: Text("Next Item"),
            ),
          ],
        ),
      ),
    );
  }
}
