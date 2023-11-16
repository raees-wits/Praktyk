// privacy_policy_screen.dart
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16.0, color: Colors.black), // Default text style
            children: <TextSpan>[
              TextSpan(text: 'Privacy Policy for [Praktyk]\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              TextSpan(text: 'Last Updated: 16 November 2023\n\n', style: TextStyle(fontWeight: FontWeight.w500)),
              _buildSectionTitle('1. Information Collection and Use'),
              _buildSectionText('When you register for an Praktyk account, we require certain information such as your email address, name, and date of birth. We collect information about your interactions with the app, such as the pages or content you view and your searches for listings.\n\n'),

              _buildSectionTitle('2. Data Sharing and Disclosure'),
              _buildSectionText('We may share your information with third-party service providers who provide services on our behalf, such as hosting, payment processing, and analytics. We may disclose your information to comply with legal processes or respond to requests from public and government authorities.\n\n'),

              _buildSectionTitle('3. Data Security'),
              _buildSectionText('We implement security measures designed to protect your information from unauthorized access, alteration, disclosure, or destruction.\n\n'),

              _buildSectionTitle('4. Children\'s Privacy'),
              _buildSectionText('Our app does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13.\n\n'),

              _buildSectionTitle('5. Changes to the Privacy Policy'),
              _buildSectionText('We reserve the right to modify this Privacy Policy at any time. If we make changes to this Privacy Policy, we will post the revised policy on this page.\n\n'),

              _buildSectionTitle('6. Your Rights'),
              _buildSectionText('You have the right to access, update, and delete your information. You can exercise these rights by logging into your account or contacting us directly.\n\n'),

              _buildSectionTitle('7. Contact Us'),
              _buildSectionText('If you have any questions about this Privacy Policy, please contact us at praktyk@gmail.com .\n\n'),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _buildSectionTitle(String title) {
    return TextSpan(text: '$title\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0));
  }

  TextSpan _buildSectionText(String text) {
    return TextSpan(text: text, style: TextStyle(fontSize: 16.0));
  }
}
