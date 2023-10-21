import 'package:flutter/material.dart';

class AccountCenterScreen extends StatefulWidget {
  const AccountCenterScreen({Key? key, required this.initialData}) : super(key: key);

  final Map<String, String> initialData;

  @override
  _AccountCenterScreenState createState() => _AccountCenterScreenState();
}

class _AccountCenterScreenState extends State<AccountCenterScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController emailController2;
  late TextEditingController passwordController;
  String userType = "Student"; // Default user type
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    // Initialize the text editing controllers with the data passed from the previous screen.
    // If the data is not available for some reason, initialize with an empty string to prevent errors.
    firstNameController = TextEditingController(text: widget.initialData['firstName'] ?? '');
    lastNameController = TextEditingController(text: widget.initialData['lastName'] ?? '');
    emailController = TextEditingController(text: widget.initialData['email'] ?? '');
    phoneController = TextEditingController(text: widget.initialData['phone'] ?? '');
    emailController2 = TextEditingController(text: widget.initialData['guardianEmail'] ?? '');
    passwordController = TextEditingController();

    // If you also pass 'userType' from the previous screen, you can initialize it as follows.
    // If 'userType' isn't passed, it defaults to "Student" as already defined in your variables.
    userType = widget.initialData['userType'] ?? userType; // keeps the default if not provided

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
                      controller: firstNameController,
                      decoration: InputDecoration(
                        label: const Text("First Name"),
                        prefixIcon: const Icon(Icons.drive_file_rename_outline_sharp),
                      ),
                    ),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        label: const Text("Last Name"),
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
                      controller: phoneController,
                      decoration: InputDecoration(
                        label: const Text("Phone No"),
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController2,
                      decoration: InputDecoration(
                        label: const Text("Gaurdian E-Mail (optional)"),
                        prefixIcon: const Icon(Icons.attach_email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
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
                          'name': firstNameController.text,
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
