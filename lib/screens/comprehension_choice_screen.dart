import 'package:e_learning_app/screens/components/comprehension_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comprehension {
  String id;
  String title;
  String text;

  Comprehension(this.id, this.title, this.text);
}

class ComprehensionChoiceScreen extends StatefulWidget {
  @override
  _ComprehensionChoiceScreen createState() => _ComprehensionChoiceScreen();
}

class _ComprehensionChoiceScreen extends State<ComprehensionChoiceScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Comprehension> comprehensions = [];

  @override
  void initState() {
    super.initState();
    loadComprehensions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadComprehensions() async {
    final querySnapshot =
        await firestore.collection("ComprehensionQuestions").get();
    setState(() {
      comprehensions = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Comprehension(doc.id, data['Title'], data['Text']);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comprehension')),
      body: ListView(
        children: [
          for (var comprehension in comprehensions)
            ComprehensionWidget(
              comprehensionID: comprehension.id,
              comprehensionTitle: comprehension.title,
              comprehensionText: comprehension.text,
            )
        ],
      ),
    );
  }
}
