import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AnkiUpdateScreen extends StatefulWidget {
  final String category;

  AnkiUpdateScreen({required this.category});

  @override
  _AnkiUpdateScreenState createState() => _AnkiUpdateScreenState();
}

class _AnkiUpdateScreenState extends State<AnkiUpdateScreen> {
  List<String> englishWords = [];
  List<String> afrikaansWords = [];
  int currentItemIndex = 0;

  late Future<void> fetchDataFuture;

  @override
  void initState() {
    super.initState();
    print('Init State Called');
    fetchDataFuture = fetchData();
  }

  Future<void> fetchData() async {
  try {
    final FirebaseStorage storage = FirebaseStorage.instance;

    // Reference to the category folder
    final Reference categoryReference =
        storage.ref('gs://praktyk-cb1c1.appspot.com/Audio/${widget.category}');
    print("Storage Path: ${categoryReference.fullPath}");

    // Fetch data from CSV files
    final englishCsvData =
        await categoryReference.child('english.csv').getData();
    final afrikaansCsvData =
        await categoryReference.child('afrikaans.csv').getData();

    // Fetch the list of MP3 files
    final mp3Files = await categoryReference.listAll();

    // Decode CSV data
    final englishCsvString = utf8.decode(englishCsvData!);
    final afrikaansCsvString = utf8.decode(afrikaansCsvData!);

    // Parse CSV data
    final englishTable = CsvToListConverter().convert(englishCsvString);
    final afrikaansTable = CsvToListConverter().convert(afrikaansCsvString);

    // Assuming the CSV structure is consistent, and the first column contains words
    setState(() {
      englishWords = englishTable.skip(1).map((row) => row[0].toString()).toList();
      afrikaansWords = afrikaansTable.skip(1).map((row) => row[0].toString()).toList();

      // Assuming MP3 files are named as sound_1.mp3, sound_2.mp3, ...
      final mp3FilesList = mp3Files.items.map((Reference mp3File) {
        return mp3File.name; // Store the names of MP3 files
      }).toList();

      // Add logic to associate each MP3 file with the corresponding word
      for (int i = 0; i < englishWords.length; i++) {
        final word = englishWords[i];
        final mp3FileName = 'sound_${i + 1}.mp3';

        // Check if the MP3 file exists for the current word
        if (mp3FilesList.contains(mp3FileName)) {
          // You might associate the MP3 file with the word, e.g., by storing it in a map
          // or adding it to a list for further use in your UI.
          // For simplicity, this example just prints the association.
          print('Word: $word, MP3 File: $mp3FileName');
        }
      }
    });
    // Inside fetchData method
print('English CSV String: $englishCsvString');
print('Afrikaans CSV String: $afrikaansCsvString');
print('MP3 Files List: $mp3Files');

// After the setState in fetchData
print('English Words: $englishWords');
print('Afrikaans Words: $afrikaansWords');

  } catch (error) {
    print('Error fetching data: $error');
    // Handle error (show a message to the user, retry, etc.)
  }
  print("we are here");
}

  void navigateToNextItem() {
    setState(() {
      currentItemIndex = (currentItemIndex + 1) % englishWords.length;
    });
  }


  @override
  Widget build(BuildContext context) {
    print('Build method called');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
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
                    'English: ${englishWords[currentItemIndex]}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Afrikaans: ${afrikaansWords[currentItemIndex]}',
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
            );
          }
        },
      ),
    );
  }
}
