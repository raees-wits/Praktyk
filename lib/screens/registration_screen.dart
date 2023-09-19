import 'package:e_learning_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? registrationType;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController gradeController = TextEditingController();

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
                //BACKGROUND COLOR
                // after the 0x part, the opacity is controlled by
                //the following 2 characters
                //***this creates the colour gradient in the bg***
                // use color-hex.com for color selections
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
              SizedBox(height: 50),DropdownButtonFormField<String>(
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
                  onChanged: (String? value) {
                    setState(() {
                      registrationType = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                buildTextField("First Name", firstNameController),
              SizedBox(height: 20),
              buildTextField("Last Name", lastNameController),
              SizedBox(height: 20),
              buildTextField("Email Address", emailController),
              SizedBox(height: 20),
              buildTextField("Phone Number", phoneController),
              SizedBox(height: 20),
              // If a student registers, then
              if (registrationType == "Student") ...[
                buildTextField("School", schoolController),
                SizedBox(height: 20),
                buildTextField("Grade", gradeController),
                SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: () {
                  print("Sign Up Pressed");
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
    ));
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

void main() {
  runApp(MaterialApp(
    home: SignUpScreen(),
  ));
}
