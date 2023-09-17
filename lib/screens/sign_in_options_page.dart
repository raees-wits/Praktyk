import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInOptions extends StatefulWidget {
  @override
  _SignInOptionsState createState() => _SignInOptionsState();
}

class _SignInOptionsState extends State<SignInOptions> {
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
                Color(0xFF71b8ff),
                Color(0xFF71b8ff),
                Color(0xFF71b8ff),
                Color(0xFF71b8ff),
              ],
            ),
          ),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Praktyk",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Welcome!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 50),

                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => print("Sign Up Pressed"),
                   child: Text("Sign Up"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFff6374),
                      padding: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                     onPressed: () => print("Login Pressed"),
                      child: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFff6374),
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

