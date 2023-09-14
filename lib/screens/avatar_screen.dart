import 'package:flutter/material.dart';

class AvatarScreen extends StatelessWidget {
  AvatarScreen();
  String prompt = 'Neo';

  @override
  Widget build(BuildContext context) {

    var title = 'My Avatar';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(15.0)),
          child: Image.network('https://robohash.org/$prompt?set=any'),
        ),
      ),
    );
  }

  void setPrompt(String newPrompt){
    prompt = newPrompt;
  }
}


