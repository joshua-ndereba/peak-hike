import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hike/screens/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Positioned.fill(
            child: Image.asset(
              'images/splash2.jpeg', 
              fit: BoxFit.cover,  
            ),
          ),
          // Overlay content on the image
          Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.,
              children: [
                // Add app logo or icon
                Icon(Icons.hiking, size: 100, color: Colors.white),
                SizedBox(height: 20),
                // Add welcome text
                Text(
                  'Welcome to Hike',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
