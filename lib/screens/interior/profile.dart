/*

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hike/screens/interior/home.dart';
import 'package:hike/screens/interior/route_tracking.dart';
import 'package:hike/widgets/bottomnavigationbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _editMode = false;
  String _id = ''; // User ID retrieved from shared preferences
  String _fullnames = '';
  String _email = '';
  String _username = '';
  String _phoneNumber = '';
  String _emergencynumber = '';
  double _height = 0.0;
  double _weight = 0.0;
  

  final TextEditingController _fullnamesController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyPhoneController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? ''; // Retrieve the 'id' from shared preferences
    });
    if (_username.isNotEmpty) {
    
      _fetchUserDetails(); // Fetch user details only if ID is available
    }else{
      print("error did not reach here");
    }
  }
Future<void> _fetchUserDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? ''; // Retrieve the 'id' from shared preferences
    });
    print("Username in SharedPreferences: $_username");

  final response = await http.get(
    Uri.parse('http://127.0.0.1/dashboard/hike/fetch.php?username=$_username'),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    // Check if the response contains a 'message' field (indicating an error)
    if (data['message'] != null) {
      
      print('Error: ${data['message']}');
      setState(() {
        // Handle the error case (user not found)
        _fullnames = '';
        _email = '';
        _phoneNumber = '';
        _emergencynumber = '';
        _weight = 0.0;
        _height = 0.0;
        _username = 'habibi';
      });
    } else {
      print("i saw this line");
      // User data found, update the UI
      setState(() {
        _fullnames = data['fullnames'];
        _email = data['email'];
        _phoneNumber = data['phone_number'];
        _emergencynumber = data['emergency_number'];
        _weight = data['weight'];
        _height = data['height'];
        _username = data['username'];
      });

      _fullnamesController.text = _fullnames;
      _emailcontroller.text = _email;
      _phoneNumberController.text = _phoneNumber;
      _emergencyPhoneController.text = _emergencynumber;
      _weightController.text = _weight.toString();
      _heightController.text = _height.toString();
      _usernameController.text = _username;
    }
  } else {
    print('Failed to load user data');
  }
}
  

  /*

  Future<void> _fetchUserDetails() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1/dashboard/hike/fetch.php?username=$_username'),
    );

     print('Response status: ${response.statusCode}');
     print('Response body: ${response.body}');
     // final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _fullnames = data['fullnames'];
        _email = data['email'];
        _phoneNumber = data['phone_number'];
        _emergencynumber = data['emergency_number'];
        _weight = data['weight'];
        _height = data['height'];
        _username = data['username'];
      });
      _fullnamesController.text = _fullnames;
      _emailcontroller.text = _email;
      _phoneNumberController.text = _phoneNumber;
      _emergencyPhoneController.text = _emergencynumber;
      _weightController.text = _weight.toString();
      _heightController.text = _height.toString();
      _usernameController.text = _username;
    } 
    else {
      print('Failed to load user data');
    }
  }
*/
  Future<void> _updateUserDetails() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1/dashboard/hike/editdata.php'),
    );

    request.fields['id'] = _id;
    request.fields['fullnames'] = _fullnamesController.text;
    request.fields['email'] = _emailcontroller.text;
    request.fields['phone_number'] = _phoneNumberController.text;
    request.fields['emergency_phone'] = _emergencyPhoneController.text;
    request.fields['weight'] = _weightController.text;
    request.fields['height'] = _heightController.text;
    request.fields['username'] = _usernameController.text;

    final response = await request.send();

     print('Response status: ${response.statusCode}');
     //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('User details updated');
    } else {
      print('Failed to update user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editMode ? 'Edit Profile' : 'Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          if (_editMode)
            IconButton(
              onPressed: _updateUserDetails,
              icon: const Icon(Icons.check, color: Colors.white),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              _buildEditableField('Full Names', _fullnamesController),
              _buildEditableField('Email', _emailcontroller),
              _buildEditableField('Phone Number', _phoneNumberController),
              _buildEditableField('Emergency Phone', _emergencyPhoneController),
              _buildEditableField('Height (cm)', _heightController, isNumeric: true),
              _buildEditableField('Weight (kg)', _weightController, isNumeric: true),
              _buildEditableField('Username', _usernameController),
              const SizedBox(height: 20.0),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_editMode) {
                      _updateUserDetails(); // Save the changes
                      setState(() {
                        _editMode = false;
                      });
                    } else {
                      setState(() {
                        _editMode = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), backgroundColor: _editMode ? Colors.teal : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    _editMode ? 'Save' : 'Edit Profile',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        screens: [
          DashboardScreen(),
          const RouteTrackingPage(),
          const ProfilePage(),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        enabled: _editMode,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.teal, fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:hike/screens/interior/home.dart';
import 'package:hike/screens/interior/route_tracking.dart';
import 'package:hike/widgets/bottomnavigationbar.dart';


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // Replace with actual image URL
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Shane',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('shane.sine@gmail.com'),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProfileStat(icon: Icons.timer, label: '2h 30m'),
                        ProfileStat(icon: Icons.local_fire_department, label: '7200 cal'),
                        ProfileStat(icon: Icons.check_circle, label: '2 Done'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Workout Plan Section
              Text('Workout Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              WorkoutCard(
                imageUrl: 'https://via.placeholder.com/100', // Replace with actual image
                title: 'Day 1 Full Body',
                duration: '29 min',
                calories: '450 kcal',
              ),
              WorkoutCard(
                imageUrl: 'https://via.placeholder.com/100',
                title: 'Dumbbell Lose Weight',
                duration: '25 min',
                calories: '440 kcal',
              ),
              WorkoutCard(
                imageUrl: 'https://via.placeholder.com/100',
                title: 'Squat Lose Weight',
                duration: '30 min',
                calories: '460 kcal',
              ),
            ],
          ),
        ),
      ),
       bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        screens: [
          const DashboardScreen(),
          const RouteTrackingPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final IconData icon;
  final String label;

  ProfileStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String duration;
  final String calories;

  WorkoutCard({
    required this.imageUrl,
    required this.title,
    required this.duration,
    required this.calories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl, fit: BoxFit.cover, width: 60, height: 60),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$duration • $calories'),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

*/


import 'package:flutter/material.dart';
import 'package:hike/screens/interior/home.dart';
import 'package:hike/screens/interior/route_tracking.dart';
import 'package:hike/widgets/bottomnavigationbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showFeatureNotAvailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature not available yet'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dawid Pietrasiak'),
        leading: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              _showFeatureNotAvailable(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.contact_mail),
            onPressed: () {
              _showFeatureNotAvailable(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/12345678'), // Replace with actual image URL
                ),
                SizedBox(width: 16),
                Text(
                  'Dawid Pietrasiak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Profile Information
            const Text(
              'dawpet@wp.pl',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            // Navigation Sections
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Personal Settings'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Members'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Team Settings'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Security'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
                ListTile(
                  leading: const Icon(Icons.upgrade),
                  title: const Text('Upgrade'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Connections'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
              ],
            ),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        screens: [
          const DashboardScreen(),
          const RouteTrackingPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}

