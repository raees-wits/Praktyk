import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notify = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Change Password'),
            leading: Icon(Icons.lock),
            onTap: () {
              // Navigate to Change Password screen
            },
          ),
          ListTile(
            title: Text('Notifications'),
            leading: Icon(Icons.notifications),
            trailing: Switch(
              value: notify,
              onChanged: (value) {
                setState(() {
                  notify = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Language'),
            leading: Icon(Icons.language),
            onTap: () {
              // Navigate to Language screen
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
              // Navigate to Privacy Policy screen
            },
          ),
          ListTile(
            title: Text('Terms and Conditions'),
            leading: Icon(Icons.gavel),
            onTap: () {
              // Navigate to Terms and Conditions screen
            },
          ),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              // Perform logout
            },
          ),
        ],
      ),
    );
  }
}
