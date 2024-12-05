import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hike/screens/interior/splash.dart';
import 'package:hike/screens/loginscreen.dart';
import 'package:hike/screens/registrationscreen.dart';
import 'package:hike/screens/interior/home.dart';


//database connection
//import 'dart:async';
//import 'package:http/http.dart' as http;
//import 'dart:convert';

void main(){
  runApp(const MyApp() as Widget);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hiking app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: const LoginScreen(),
      initialRoute: Routes.splash,
      routes: Routes.routes,
    );
  }
}

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String dashboard = '/dashboard';

  static final routes = {
    splash: (context) => SplashScreen(),
    login: (context) => const LoginScreen(),
    registration: (context) => const RegistrationScreen(),
    dashboard: (context) => const DashboardScreen(),
  };
}