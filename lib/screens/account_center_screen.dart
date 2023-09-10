import 'package:flutter/material.dart';

class AccountCenterScreen extends StatelessWidget {
  const AccountCenterScreen({Key? key,required this.initialData}) : super(key: key);


  final String AccountCenterTitle = "Account Center";
  final Map<String, String> initialData;

  @override
  Widget build(BuildContext context) {


    TextEditingController nameController = TextEditingController(text: initialData['name']);
    TextEditingController emailController = TextEditingController(text: initialData['email']);
    TextEditingController emailController2 = TextEditingController(text: initialData['guardian-email']);
    TextEditingController passwordController = TextEditingController(text: initialData['password']);



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text(
          AccountCenterTitle,
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
                        prefixIcon: const Icon(Icons.person_outline),
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
                    // const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        prefixIcon: const Icon(Icons.fingerprint_outlined),
                      ),
                      obscureText: true, // Obscure the password
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
                        child: const Text("Done", style: TextStyle(color: Colors.black)),
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
