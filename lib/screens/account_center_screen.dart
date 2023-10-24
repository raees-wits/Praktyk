import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountCenterScreen extends StatefulWidget {
  const AccountCenterScreen({Key? key, required this.initialData}) : super(key: key);

  final Map<String, String> initialData;

  @override
  _AccountCenterScreenState createState() => _AccountCenterScreenState();
}

class _AccountCenterScreenState extends State<AccountCenterScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController emailController2;
  late TextEditingController passwordController;
  String userType = "Student"; // Default user type

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.initialData['firstName'] ?? '');
    lastNameController = TextEditingController(text: widget.initialData['lastName'] ?? '');
    emailController = TextEditingController(text: widget.initialData['email'] ?? '');
    phoneController = TextEditingController(text: widget.initialData['phone'] ?? '');
    emailController2 = TextEditingController(text: widget.initialData['guardianEmail'] ?? '');
    passwordController = TextEditingController(); // Assuming password is passed for the sake of completion
    userType = widget.initialData['userType'] ?? userType;
  }

  Future<void> updateUserDetails() async {
    try {
      final User? currentUser = auth.currentUser;
      if (currentUser == null) {
        // Handle the case where there is no user logged in.
        return;
      }

      final String userId = currentUser.uid;

      Map<String, dynamic> updateData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        // Include additional fields as necessary
      };

      if (emailController2.text.isNotEmpty) {
        updateData['guardianEmail'] = emailController2.text;
      }

      await firestore.collection('Users').doc(userId).update(updateData);

      // After updating, you may want to navigate or give some feedback
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      print("An error occurred1: $e");
      // Here, you might want to show a Snackbar or a dialog with the error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        title: Text(
          "Account Center",
          style: Theme.of(context).textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipOval(
                      child: const Image(
                        image: AssetImage("assets/images/profile.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.deepPurpleAccent,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        label: const Text("First Name"),
                        prefixIcon: const Icon(Icons.drive_file_rename_outline),
                      ),
                    ),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        label: const Text("Last Name"),
                        prefixIcon: const Icon(Icons.drive_file_rename_outline),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        label: const Text("E-Mail"),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        label: const Text("Phone No"),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),
                    TextFormField(
                      controller: emailController2,
                      decoration: InputDecoration(
                        label: const Text("Guardian E-Mail (optional)"),
                        prefixIcon: const Icon(Icons.attach_email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.contains('@')) {
                          return null; // valid or empty is allowed
                        }
                        return 'Please enter a valid email'; // invalid email
                      },
                    ),
                    Divider(color: Colors.black),
                    DropdownButtonFormField<String>(
                      value: userType,
                      items: ["Teacher", "Student", "Parent"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          userType = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        label: const Text("User Type"),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: updateUserDetails, // This saves the data to Firestore
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurpleAccent,
                          onPrimary: Colors.white,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
