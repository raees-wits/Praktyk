import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? registrationType;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x66ff6374),
                Color(0x99ff6374),
                Color(0xccff6374),
                Color(0xFFff6374),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Registration Type',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: const Text("Please select registration type"),
                    value: registrationType,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a registration type';
                      }
                      return null;
                    },
                    items: const [
                      DropdownMenuItem(
                        child: Text("Student"),
                        value: "Student",
                      ),
                      DropdownMenuItem(
                        child: Text("Teacher"),
                        value: "Teacher",
                      ),
                      DropdownMenuItem(
                        child: Text("Parent"),
                        value: "Parent",
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        registrationType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  buildTextField("First Name", firstNameController, true),
                  const SizedBox(height: 20),
                  buildTextField("Last Name", lastNameController, true),
                  const SizedBox(height: 20),
                  buildTextField("Email Address", emailController, true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email address';
                        } else if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(height: 20),
                  buildTextField("Phone Number", phoneController, true,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        } else if (value.length != 10) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(height: 20),
                  buildTextField("Password", passwordController, true, isPassword: true),
                  const SizedBox(height: 20),
                  buildTextField("Confirm Password", confirmPasswordController, true, isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(height: 20),
                  if (registrationType == "Student") ...[
                    buildTextField("School", schoolController, true),
                    const SizedBox(height: 20),
                    buildTextField("Grade", gradeController, true),
                    const SizedBox(height: 20),
                  ],
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          Map<String, dynamic> userData = {
                            'userType': registrationType,
                            'firstName': firstNameController.text,
                            'lastName': lastNameController.text,
                            'email': emailController.text,
                            'phone': phoneController.text,
                          };

                          if (registrationType == "Student") {
                            userData['school'] = schoolController.text;
                            userData['grade'] = gradeController.text;
                          }

                          _firestore.collection('Users').doc(userCredential.user!.uid).set(userData);

                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()
                              )
                          );
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'An error occurred')));
                        }
                      }
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hint, TextEditingController controller, bool isRequired,
      {TextInputType keyboardType = TextInputType.text, bool isPassword = false,
        FormFieldValidator<String>? validator}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          hint,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60,
          child: TextFormField(
            validator: validator,
            keyboardType: keyboardType,
            obscureText: isPassword,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void main() {
    runApp(MaterialApp(
      home: SignUpScreen(),
    ));
  }
}

