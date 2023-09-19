import 'package:flutter/material.dart';
import 'account_center_screen.dart';  // Replace with the actual path
import 'profile_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super (key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  String name = "Default Name";  // Default name
  String email = "example@email.com";  // Default email
  String guardianEmail = "example@gaurdian.com"; // De
  String password = "password123";  // Default password

  @override
  Widget build(BuildContext context){
    return Material(
      color: Color(0xfffffffff), //set the background color to any color
      child: ListView(
        physics: BouncingScrollPhysics(), //use this for bouncing experience
        children: [
          Container(height: 35),
          userTile(),
          divider(),
          colorTiles(),
          divider(),
          bwTiles(),
        ],
      ),
    );
  }

  Widget userTile() {
    String url = "assets/images/profile.png";
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(url),
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("Student"),
    );
  }


  Widget divider(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget colorTiles(){
    return Column(
        children:[
          colorTile(Icons.person_outline, Colors.deepPurple, "Account Center"),
          colorTile(Icons.settings_outlined, Colors.blue, "Settings"),
          colorTile(Icons.people_outline, Colors.pink, "Friends"),
          colorTile(Icons.star_outline, Colors.orange, "Achievements"),
        ],
    );
  }

  Widget bwTiles(){
      Color color = Colors.black;
      return Column(
        children:[
          bwTile(Icons.help_outlined,"Help"),
          bwTile(Icons.info_outline,"Community Guidelines"),
          // bwTile(Icons.info_outline,"Help")
        ]
      );
  }

  Widget bwTile(IconData icon, String text){
    return colorTile(icon, Colors.black, text, blackAndWhite: true);
  }

  Widget colorTile(IconData icon, Color color, String text, {bool blackAndWhite = false}){
    Color pickedColor = Color(0xfff3f4fe);
    return GestureDetector(
      onTap: () async {
        if (text == "Account Center") {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountCenterScreen(
              initialData: {
                'name': name,
                'email': email,
                'guardian-email': guardianEmail,
                'password': password,
              },
            )),
          );
          if (result != null) {
            setState(() {
              name = result['name'] ?? name;
              email = result['email'] ?? email;
              guardianEmail = result['guardian-email'] ?? guardianEmail;
              password = result['password'] ?? password;
            });
          }
        }
        else if (text == "Settings") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        }
      },
      child: ListTile(
        leading : Container(
            child: Icon(icon, color: color),
            height: 45,
            width : 45,
            decoration: BoxDecoration(
                color: blackAndWhite? pickedColor : color.withOpacity(0.09),
                borderRadius: BorderRadius.circular(18)
            )
        ),
        title: Text(text,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      trailing : Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
      ),
    );
  }
}