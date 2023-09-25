import 'package:e_learning_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
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
                ]
            ),
          ),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Registration Type',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    hint: Text("Please select registration type"),
                    value: registrationType,
                    items: [
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
                    validator: (value) =>
                    value == null
                        ? 'Please select a registration type'
                        : null,
                    onChanged: (String? value) {
                      setState(() {
                        registrationType = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  buildTextField("First Name", firstNameController, true),
                  SizedBox(height: 20),
                  buildTextField("Last Name", lastNameController, true),
                  SizedBox(height: 20),
                  buildTextField("Email Address", emailController, true,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Email Address';
                        }
                        // Add regex for email validation
                        final regexEmail = RegExp(
                            r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                        if (!regexEmail.hasMatch(value)) {
                          return 'Enter a valid Email Address';
                        }
                        return null;
                      }),
                  SizedBox(height: 20),
                  buildTextField("Phone Number", phoneController, true,
                      keyboardType: TextInputType.phone, validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.length != 10) {
                          return 'Phone number must be 10 digits long';
                        }
                        return null;
                      }),
                  SizedBox(height: 20),
                  buildTextField(
                      "Password", passwordController, true, isPassword: true),
                  SizedBox(height: 20),
                  buildTextField(
                      "Confirm Password", confirmPasswordController, true,
                      isPassword: true, validator: (value) {
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  }),
                  if (registrationType == "Student") ...[
                    SizedBox(height: 20),
                    buildTextField("School", schoolController, true),
                    SizedBox(height: 20),
                    buildTextField("Grade", gradeController, true),
                    SizedBox(height: 20),
                  ],
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        print("Form is valid");
                        // Process data
                      } else {
                        print("Form is invalid");
                      }
                    },
                    child: Text("Sign Up",
                        style: TextStyle(
                          color: Colors.black,
                        )),
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

  Widget buildTextField(String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          hint,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2)
                )
              ]
          ),
          height: 60,
          child: TextField(
            controller: controller,
            keyboardType: hint == "Phone Number" ? TextInputType.phone : TextInputType.text,
            style: TextStyle(
                color: Colors.black87
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                    hint == "Phone Number" ? Icons.phone
                        : (hint == "Email Address" ? Icons.email
                        : Icons.person),
                    color: kpink
                ),
                hintText: hint,
                hintStyle: TextStyle(
                    color: Colors.black38
                )
            ),
          ),
        )
      ],
    );
  }

}

Widget buildPasswordField(String hint, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        hint,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
      ),
      SizedBox(height: 10),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2)
              )
            ]
        ),
        height: 60,
        child: TextField(
          controller: controller,
          obscureText: true, // Obscures the text input for passwords
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(Icons.lock, color: kpink), // Updated to a lock icon for passwords
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black38)
          ),
        ),
      )
    ],
  );
}


void main() {
  runApp(MaterialApp(
    home: SignUpScreen(),
  ));
}
