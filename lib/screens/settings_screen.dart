import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_change_password_screen.dart'; // Import the new screen
import 'components/privacy_policy_screen.dart';
import 'components/terms_conditions_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notify = false;
  String accountCenterPassword = "initialPassword"; // Define it here or pass it as an argument

  // Function to sign out the user
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.headline6?.copyWith(
          fontWeight: FontWeight.bold, color: Colors.black,
        )),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Change Password'),
            leading: Icon(Icons.lock),
            onTap: () async {
              final newPassword = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                ),
              );
              if (newPassword != null) {
                // Update accountCenterPassword
                setState(() {
                  accountCenterPassword = newPassword;
                });
              }
            },
          ),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            leading: Icon(Icons.privacy_tip),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Terms and Conditions'),
            leading: Icon(Icons.gavel),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsConditionsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              _signOut().then((_) {
                // Optionally, navigate the user to the login screen after logging out
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
          ),
        ],
      ),
    );
  }
}
