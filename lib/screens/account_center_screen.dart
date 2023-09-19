import 'package:flutter/material.dart';

class AccountCenterScreen extends StatefulWidget {
  const AccountCenterScreen({Key? key, required this.initialData}) : super(key: key);

  final Map<String, String> initialData;

  @override
  _AccountCenterScreenState createState() => _AccountCenterScreenState();
}

class _AccountCenterScreenState extends State<AccountCenterScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController emailController2;
  late TextEditingController passwordController;
  String userType = "Student"; // Default user type
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialData['name']);
    emailController = TextEditingController(text: widget.initialData['email']);
    emailController2 = TextEditingController(text: widget.initialData['guardian-email']);
    passwordController = TextEditingController(text: widget.initialData['password']);
  }

  String obscurePassword(String password) {
    return password.length > 3
        ? password.substring(0, 2) +
        '*' * (password.length - 3) +
        password.substring(password.length - 1)
        : password;
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
                        color: Colors.black,
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
                      controller: nameController,
                      decoration: InputDecoration(
                        label: const Text("Full Name"),
                        prefixIcon: const Icon(Icons.drive_file_rename_outline_sharp),
                      ),
                    ),
                    // const SizedBox(height: 20),
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
                    // const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        label: const Text("Phone No"),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController2,
                      decoration: InputDecoration(
                        label: const Text("Gaurdian E-Mail"),
                        prefixIcon: const Icon(Icons.attach_email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    ListTile(
                      title: Text("Password"),
                      subtitle: Text(
                        obscureText ? obscurePassword(passwordController.text) : passwordController.text,
                      ),
                      trailing: IconButton(
                        icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                    // const SizedBox(height: 20),
                    Divider(color: Colors.black),  // <-- Add this line
                    DropdownButtonFormField<String>(
                      value: userType,
                      items: ["Teacher", "Student", "Parent"]
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        userType = newValue!;
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
                        onPressed: () => // Validate and save data
                        Navigator.pop(context, {
                          'name': nameController.text,
                          'email': emailController.text,
                          'guardian-email': emailController2.text,
                          'password': passwordController.text,
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent, side: BorderSide.none, shape: const StadiumBorder()),
                        child: const Text("Done", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
