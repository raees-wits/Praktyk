import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/screens/forgot_password_screen.dart';
import 'package:e_learning_app/screens/home_screen.dart';
import 'package:e_learning_app/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget{

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isRememberMe = false;


  bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return regex.hasMatch(email);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 4),
      backgroundColor: Colors.redAccent,
    ));
  }

  Widget buildEmail(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Email',
            style: TextStyle(
                color: Colors.white,
                fontSize:16,
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
                      offset: Offset(0,2)
                  )
                ]
            ),
            height: 60,
            child: TextField(
              controller: emailController,  // <-- Add this line
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                  color: Colors.black87
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                      Icons.email,
                      color: kpink,
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      color: Colors.black38
                  )
              ),
            ),
          )
        ]
    );
  }

  Widget buildPassword(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Password',
            style: TextStyle(
                color: Colors.white,
                fontSize:16,
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
                      offset: Offset(0,2)
                  )
                ]
            ),
            height: 60,
            child: TextField(
              //obscure text to hide password
              controller: passwordController,  // <-- Add this line
              obscureText: true,
              style: TextStyle(
                  color: Colors.black87
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                      Icons.lock,
                      color: kpink
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: Colors.black38
                  )
              ),
            ),
          )
        ]
    );
  }

  Widget buildForgotPassBtn(){
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
          );
        },
        child: Text(
            'Forgot Password?',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            )
        ),
      ),
    );
  }

  Widget buildRememberCb(){
    return Container(
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isRememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (bool? value){
                setState(() {
                  print("remember me pressed");
                  isRememberMe = value ?? false;
                });
              },
            ),
          ),
          const Text(
            'Remember Me',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginBtn(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (isValidEmail(emailController.text)) {
            try {
              // authenticate against firebase
              UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              );

              // Optionally, check if the user exists in the 'Users' collection
              DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userCredential.user!.uid).get();

              if (userDoc.exists) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              } else {
                showMessage("User does not exist in the database");
              }
            } catch (e) {
              // Handle authentication error
              showMessage("Error logging in. Please check your credentials. Details: $e");
            }
          } else {
            // Display message for invalid email address
            showMessage("Invalid email address");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          ),
        ),
        child: Text(
          'LOGIN',
          style:TextStyle(
              color: kpink,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget buildSignUpBtn(){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
            MaterialPageRoute(
                builder: (context) => SignUpScreen())
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              ),
            ),
            TextSpan(
              text: 'Sign up',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSkipBtn() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      child: Text('Skip', style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {

    // background color
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
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
                      //use color-hex.com for color selections
                      colors: [
                        Color(0x66ff6374),
                        Color(0x99ff6374),
                        Color(0xccff6374),
                        Color(0xFFff6374),
                      ]
                  ),
                ),
                child: SingleChildScrollView(

                  //Physics parameter makes sign in page scrollable

                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 120
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      //sign in text below
                      Text(
                        'Sign In/Teken Aan',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                      //builds email input box on screen
                      //note: sized boxes height parameter used for spacing in column
                      SizedBox(height: 50),
                      buildEmail(),

                      //Password box on screen
                      SizedBox(height: 20),
                      buildPassword(),
                      buildForgotPassBtn(),
                      buildRememberCb(),
                      buildLoginBtn(),
                      buildSignUpBtn(),
                      SizedBox(height: 10),  // Provide some spacing
                      buildSkipBtn(),       // Add the skip button here
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}