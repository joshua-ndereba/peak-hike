import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hike/widgets/custombutton.dart';
import 'package:hike/widgets/textfield.dart';
import 'package:http/http.dart' as http;

final usernamecont = TextEditingController();
final passwordcont = TextEditingController();
final passwordAgain = TextEditingController();
final emailcont = TextEditingController();
final fullnamecont = TextEditingController();
final weightcont = TextEditingController();
final heightcont = TextEditingController();
final phonecont = TextEditingController();
final emergencycont = TextEditingController();

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16.0),
              MyTextField(
                controller: fullnamecont,
                hint: "Enter Full Names *",
                icon: Icons.person, obscureText: false,
              ),
              const SizedBox(height: 16.0),
              MyTextField(
                controller: emailcont,
                hint: "Enter Email *",
                icon: Icons.mail, obscureText: false,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: weightcont,
                      hint: "Weight (kg) (Optional)",
                      icon: Icons.line_weight, obscureText: false,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: MyTextField(
                      controller: heightcont,
                      hint: "Height (cm) (Optional)",
                      icon: Icons.height, obscureText: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: phonecont,
                      hint: "Phone (Optional)",
                      icon: Icons.phone, obscureText: false,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: MyTextField(
                      controller: emergencycont,
                      hint: "Emergency (Optional)",
                      icon: Icons.phone_android, obscureText: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              MyTextField(
                controller: usernamecont,
                hint: "Enter Username *",
                icon: Icons.person_2, obscureText: false,
              ),
              const SizedBox(height: 16.0),
             TextField(
            obscureText: true,
            controller: passwordcont,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
              TextField(
            obscureText: true,
            controller: passwordAgain,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
              CustomButton(
                text: 'Register',
                onPressed: () async {
                  if (fullnamecont.text.isEmpty) {
                    Get.snackbar("Error", "Full name is required");
                  } else if (emailcont.text.isEmpty) {
                    Get.snackbar("Error", "Email is required");
                  } else if (usernamecont.text.isEmpty) {
                    Get.snackbar("Error", "Username is required");
                  } else if (passwordcont.text.isEmpty ||
                      passwordAgain.text.isEmpty ||
                      passwordcont.text != passwordAgain.text) {
                    Get.snackbar("Error", "Password is empty or doesn't match");
                  } else {
                    var body = {
                      'fullnames': fullnamecont.text.trim(),
                      'email': emailcont.text.trim(),
                      'phone_number': phonecont.text.trim(),
                      'emergency_number': emergencycont.text.trim(),
                      'weight': weightcont.text.trim(),
                      'height': heightcont.text.trim(),
                      'username': usernamecont.text.trim(),
                      'password': passwordcont.text.trim(),
                    };
                    final response = await http.post(
                      Uri.parse("http://localhost/backend/register.php"),
                      body: body,
                    );
                    print('Response status: ${response.statusCode}');
                    if (response.statusCode == 200) {
                      final serverData = jsonDecode(response.body);
                      if (serverData['code'] == 1) {
                        Get.snackbar("Success", "Registration successful");
                        Get.toNamed("/login");
                      }
                    } else {
                      Get.snackbar("Error", "Registration failed");
                    }
                  }
                },
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: "Back to Login",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
