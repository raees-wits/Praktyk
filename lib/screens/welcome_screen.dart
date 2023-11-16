// ignore_for_file: prefer_const_constructors

import 'package:e_learning_app/constants.dart';
import 'package:e_learning_app/screens/comprehension_choice_screen.dart';
import 'package:e_learning_app/screens/login_screen.dart';

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblue,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color(0xFFFDD1C1),
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      Expanded(child: Image.asset("assets/images/welcome.jpg",  fit: BoxFit.cover))
                    ],
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  color:  Color(0xFFFDD1C1),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: kblue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Spacer(),
                          Text(
                            "Afrikaans Made Makliker",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Learn with pleasure \n"
                            "wherever you are!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black54,
                              wordSpacing: 2.5,
                              height: 1.5,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(
                            flex: 3,
                          ),
                          //replace size-box with spacer
                          Row(
                            //button position
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                height: 60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                color: kpink,
                                onPressed: () {
                                  //home screen path
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text(
                                  "Begin",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
