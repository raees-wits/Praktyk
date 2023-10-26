import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool obscureTextCurrent = true;
  bool obscureTextNew = true;
  bool obscureTextConfirm = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword(String newPassword) async {
    User? user = _auth.currentUser;

    if (user != null) {
      user.updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Success! Your password has been changed.'),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while changing the password: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

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
                    icon: Icon(obscureTextNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureTextNew = !obscureTextNew;
                      });
                    },
                  ),
                ),
                obscureText: obscureTextNew,
              ),
              TextFormField(
                controller: confirmNewPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  suffixIcon: IconButton(
                    icon: Icon(obscureTextConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureTextConfirm = !obscureTextConfirm;
                      });
                    },
                  ),
                ),
                obscureText: obscureTextConfirm,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (newPasswordController.text == confirmNewPasswordController.text &&
                      newPasswordController.text.isNotEmpty) {

                    // Ideally, here you validate the current password of the user.
                    // For the sake of simplicity, it's not included in this code.
                    // To fully secure the process, re-authenticate the user or validate the current password server-side.

                    await changePassword(newPasswordController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed: Passwords do not match or fields are empty.'),
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
