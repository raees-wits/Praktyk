import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'account_center_screen.dart'; // Replace with the actual path if different
import 'settings_screen.dart'; // Replace with the actual path if different

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = "Loading...";
  String firstName = "";
  String lastName = "";
  String grade = "";
  String phone = "";
  String school = "";
  String userType = "Loading...";
  String email = "";


  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          setState(() {
            userType = userDoc['userType'] ?? "Not specified";
            email = userDoc['email'] ?? "not specified";
            phone = userDoc['phone'] ?? "not specified";
            firstName = userDoc['firstName'] ?? "not specified";
            lastName = userDoc['lastName'] ?? "not specified";
            name = "$firstName $lastName";
            grade = userDoc['grade'] ?? "not specified";
            school = userDoc['school'];

          });
        } else {
          // Document doesn't exist, handle it accordingly
          print('No user record corresponding to the current user');
        }
      } catch (e) {
        // If there's an error, log it for debugging
        print('Error retrieving user data: $e');
      }
    } else {
      // Optionally handle the scenario where currentUser is null
      print('No user is currently signed in.');
      name = "Unregistered user";
      userType = "Guest";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xfffffffff),
      child: ListView(
        physics: BouncingScrollPhysics(),
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
      subtitle: Text(userType),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget colorTiles() {
    return Column(
      children: [
        colorTile(Icons.person_outline, Colors.deepPurple, "Account Center"),
        colorTile(Icons.settings_outlined, Colors.blue, "Settings"),
        colorTile(Icons.people_outline, Colors.pink, "Friends"),
        colorTile(Icons.star_outline, Colors.orange, "Achievements"),
      ],
    );
  }

  Widget bwTiles() {
    return Column(
      children: [
        bwTile(Icons.help_outline, "Help"),
        bwTile(Icons.info_outline, "Community Guidelines"),
      ],
    );
  }

  Widget bwTile(IconData icon, String text) {
    return colorTile(icon, Colors.black, text, blackAndWhite: true);
  }

  Widget colorTile(IconData icon, Color color, String text, {bool blackAndWhite = false}) {
    Color pickedColor = Color(0xfff3f4fe);
    return GestureDetector(
      onTap: () async {
        // Conditional logic based on the tile's text
        if (text == "Account Center") {
          // Navigate to the Account Center Screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountCenterScreen(
                initialData: {
                  'firstName': firstName,
                  'lastName': lastName,
                  'email': email,
                  'phone': phone,
                  'userType' : userType,
                  'grade' : grade,
                  'school' : school
                },
              ),
            ),
          );
          // After returning from the Account Center Screen, update any information if necessary
          if (result != null) {
            setState(() {

              firstName = result['name'] ?? firstName;
              lastName= result['name'] ?? lastName;
              email= result['name'] ?? email;
              phone= result['name'] ?? phone;
              userType= result['name'] ?? userType;
              grade= result['name'] ?? grade;
              school= result['name'] ?? school;
            });
          }
        } else if (text == "Settings") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        }
        // You can add more conditions here for other tiles like "Friends" or "Achievements"
      },
      child: ListTile(
        leading: Container(
          child: Icon(icon, color: color),
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: blackAndWhite ? pickedColor : color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20),
      ),
    );
  }
}
