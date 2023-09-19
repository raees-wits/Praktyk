import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String currentPassword;

  ChangePasswordScreen({required this.currentPassword});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  String accountCenterPassword = "password123"; // This should be fetched from AccountCenterScreen

  bool obscureTextCurrent = true;
  bool obscureTextNew = true;
  bool obscureTextConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  suffixIcon: IconButton(
                    icon: Icon(obscureTextCurrent ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureTextCurrent = !obscureTextCurrent;
                      });
                    },
                  ),
                ),
                obscureText: obscureTextCurrent,
              ),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(obscureTextCurrent ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureTextCurrent = !obscureTextCurrent;
                      });
                    },
                  ),
                ),
                obscureText: obscureTextCurrent,
              ),
              TextFormField(
                controller: confirmNewPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: IconButton(
                    icon: Icon(obscureTextCurrent ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureTextCurrent = !obscureTextCurrent;
                      });
                    },
                  ),
                ),
                obscureText: obscureTextCurrent,
              ),
              ElevatedButton(
                onPressed: () {
                  if (currentPasswordController.text == accountCenterPassword &&
                      newPasswordController.text == confirmNewPasswordController.text &&
                      newPasswordController.text.isNotEmpty) {
                    // Update the password in AccountCenterScreen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
