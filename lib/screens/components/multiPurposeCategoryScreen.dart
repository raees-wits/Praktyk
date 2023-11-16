import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../MultipleChoiceScreen.dart';

class MultiPurposeCategoryScreen extends StatelessWidget {
  final String questionType;

  MultiPurposeCategoryScreen({Key? key, required this.questionType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference categories = FirebaseFirestore.instance.collection(questionType);

    return Scaffold(
      appBar: AppBar(
        title: Text("Category Screen"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: categories.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            List<String> documentIds = snapshot.data!.docs.map((doc) => doc.id).toList();

            return ListView.builder(
              itemCount: documentIds.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultipleChoiceScreen(category: documentIds[index]),
                        ),
                      );
                    },
                    child: Text(documentIds[index]),
                  ),
                );
              },
            );
          } else {
            //shows loading indicator until the data is loaded from the database
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
