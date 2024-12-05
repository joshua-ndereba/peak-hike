/*__creen> {
  String? username; // Store username from SharedPreferences

  @override
  void initState() {
    super.initState();
    readInitialValue();
    print("Initial username from SharedPreferences: $username");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background image with appropriate asset path
      backgroundColor: Colors.transparent,
      body: Stack( // Use Stack for layering
        children: [
          // Background image with adjusted brightness
          
          Image.asset(
            'assets/images/featured1.jpeg', // Replace with your asset path
            fit: BoxFit.cover, // Ensure image fills the screen
            color: Colors.black.withOpacity(0.3), // Adjust brightness
            colorBlendMode: BlendMode.multiply, // Blend with background
          ),
          // Login form centered on top
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0), // Add padding to boxes
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                color: Colors.white.withOpacity(0.8), // Semi-transparent background
                
        
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:[Colors.blue, Color.fromARGB(255, 99, 164, 101)])
      
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Avoid excessive space
                children: [
                  _icon(),
                  const SizedBox(height: 16.0),
                  MyTextField(
                    controller: usernamecont,
                    hint: "enter username: ",
                    icon: Icons.person,
                  ),
                  MyTextField(
                    controller: passwordcont,
                    hint: "enter password: ",
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 16.0),
                  CustomButton(
                    text: 'Login',
                    onPressed: () async {
                      if(usernamecont.text.isEmpty){
                        Get.snackbar("Error", "Enter username");

                      }else if(passwordcont.text.isEmpty){
                        Get.snackbar("Error", "Enter password");

                      }
                      else{
                        final response= await http.get(Uri.parse("http://localhost/dashboard/hike/login.php?username=${usernamecont.text}&password=${passwordcont.text}"));
                        
                        if(response.statusCode==200){
                          final serverData = jsonDecode(response.body);
                          if (serverData['code']==1){

                             //SharedPreferences prefs = await SharedPreferences.getInstance();
                             //prefs.setString('username', serverData['username'].toString());
                             // print("Username in SharedPreferences: $username");
                            Get.toNamed('/dashboard');
                          }
                          else{
                            Get.snackbar("wrong credential", serverData("message"));
                          }
                        }else{
                          Get.snackbar("server error", "error logging in.");
                        }
                      }
                      // Login logic (replace with your actual implementation)
                      //Navigator.pushReplacementNamed(context, '/dashboard');

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString("username", usernamecont.text);
                      //print("Username in SharedPreferences: $username");
                     

                    },
                  ),
                  const SizedBox(height: 3.0),
                  const Text("Don't have an account?"),
                  CustomButton(
                    text: 'Register',
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, '/registration');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }

  readInitialValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    setState(() {}); // Update UI with retrieved username
   // print("Username in SharedPreferences: $username");
  }
}

*/


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hike/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final usernamecont = TextEditingController();
final passwordcont = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Adding gradient background
          gradient: LinearGradient(
            colors: [Color(0xFF00C9A7), Color(0xFF92FE9D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Add padding around the card
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Card background color
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  bool isWideScreen = constraints.maxWidth > 600;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isWideScreen)
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: _buildLoginForm(context),
                          ),
                        ),
                      if (isWideScreen)
                        const SizedBox(width: 16.0), // Space between sections

                      Expanded(
                        flex: isWideScreen ? 1 : 2,
                        child: isWideScreen
                            ? _buildCircularDesign()
                            : Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: _buildLoginForm(context),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Login Form Section
  Widget _buildLoginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            "Welcome back! Please enter your details.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 30),

          // Email Input Field
          MyTextField(
                    controller: usernamecont,
                    hint: "enter username: ",
                    icon: Icons.person, obscureText: false,
                  ),
          const SizedBox(height: 20),

          // Password Input Field
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

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text("Remember for 30 days"),
                ],
              ),
              
            ],
          ),
          const SizedBox(height: 20),

          // Sign In Button
          ElevatedButton(
             onPressed: () async {
                      if(usernamecont.text.isEmpty){
                        Get.snackbar("Error", "Enter username");

                      }else if(passwordcont.text.isEmpty){
                        Get.snackbar("Error", "Enter password");

                      }
                      else{
                        final response= await http.get(Uri.parse("http://localhost/dashboard/hike/login.php?username=${usernamecont.text}&password=${passwordcont.text}"));
                        
                        if(response.statusCode==200){
                          final serverData = jsonDecode(response.body);
                          if (serverData['code']==1){

                             //SharedPreferences prefs = await SharedPreferences.getInstance();
                             //prefs.setString('username', serverData['username'].toString());
                             // print("Username in SharedPreferences: $username");
                            Get.toNamed('/dashboard');
                          }
                          else{
                            Get.snackbar("wrong credential", serverData("message"));
                          }
                        }else{
                          Get.snackbar("server error", "error logging in.");
                        }
                      }
                      // Login logic (replace with your actual implementation)
                      //Navigator.pushReplacementNamed(context, '/dashboard');

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString("username", usernamecont.text);
                      //print("Username in SharedPreferences: $username");
                     

                    },
            
            //onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color.fromARGB(255, 121, 214, 106),
            ),
            child: const Text(
              "Sign In",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Google Sign-In Button
         

          // Sign Up Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don’t have an account? "),
              GestureDetector(
                onTap: () {Navigator.pushReplacementNamed(context, '/registration');},
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    color: Color.fromARGB(255, 50, 156, 213),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Circular Design Section
  Widget _buildCircularDesign() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple.withOpacity(0.1),
            ),
          ),
          Container(
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }
}

