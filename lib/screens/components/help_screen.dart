// help_screen.dart
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & FAQs'),
        backgroundColor: Colors.grey, // Setting the app bar color to grey
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: _buildFAQText(_faqContent()),
      ),
    );
  }

  RichText _buildFAQText(List<TextSpan> faqTextSpans) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16.0, color: Colors.black), // Default text style
        children: faqTextSpans,
      ),
    );
  }

  List<TextSpan> _faqContent() {
    return [
      TextSpan(text: 'What is Praktyk?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Praktyk is an educational application designed to teach students the Arikaans language.\n\n'),
      TextSpan(text: 'How can I start learning Afrikaans with this app?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Student: Once you land on the home page, you will have multiple categories to Afrikaans learning categories to choose from. '
          'Select a category you would like to practise and start learning! Otherwise head to our community page to post your very own questions. \n\n'),
      TextSpan(text: 'Is this app suitable for beginners?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'This app is suitable for all users and accomoodates learning that ranges from no experience with Afrikaans, to teacher level Afrikaans\n\n'),
      TextSpan(text: 'What kind of learning materials are available?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Everything from vocabulary, grammar rules, pronounciation, games and comprehension texts. '
          'PLEASE NOTE: Comprehension texts are specific to grade and teacher.\n\n'),
      TextSpan(text: 'Can I track my progress in the app?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Yes, navigate to your daily goals and or the leaderboards page.\n\n'),
      TextSpan(text: 'Is there a community or forum where I can interact with other learners?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Yes there is a community page for a collaborative learning experience between teacher and student.\n\n'),
      TextSpan(text: 'Are there any subscription fees or in-app purchases?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'No there are no subscription fees or in-app purchases.\n\n'),
      TextSpan(text: 'How can I get help if I encounter issues with the app?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Navigate to the Help page in the profile screen to view the frequently asked questions.\n\n'),
      TextSpan(text: 'Can I learn Afrikaans on my own using this app?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Yes the app is tailored for independent use.\n\n'),
      TextSpan(text: 'How often is the app content updated?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Through the use of teacher users, the apps content is regularly updated by teachers posting new content.\n\n'),
      TextSpan(text: 'Is the app available on multiple devices?\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      TextSpan(text: 'Yes the app is available to android devices and use on web browser.\n\n'),


      // Add more TextSpan widgets for each question and answer
      // ...
    ];
  }
}
