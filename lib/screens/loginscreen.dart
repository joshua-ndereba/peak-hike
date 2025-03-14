


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hike/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final usernamecont = TextEditingController();
final passwordcont = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
  
}
class _LoginScreenState extends State<LoginScreen> {
  //const LoginScreen({super.key});
  bool _obscureText = true;
 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/featured2.jpeg'), // Path to your image
            fit: BoxFit.cover,
            ),
          // Adding gradient background
          
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Add padding around the card
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 123, 188, 20).withOpacity(0.9), // Card background color
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 208, 37, 37).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                //fit: BoxFit.fitWidth,
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
  obscureText: _obscureText, // Controls password visibility
  controller: passwordcont,
  decoration: InputDecoration(
    labelText: "Password",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    prefixIcon: const Icon(Icons.lock), // Lock icon on the left
    suffixIcon: IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility : Icons.visibility_off, // Eye icon toggle
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText; // Toggle obscureText state
        });
      },
    ),
  ),
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

