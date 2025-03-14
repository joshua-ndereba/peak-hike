

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        title: const Text('Hiking'),
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
                  backgroundImage:  AssetImage('images/splash.jpeg'), // Replace with actual image URL
                ),
                SizedBox(width: 16),
                Text(
                  'Jneid@gmail.com',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Profile Information
            const Text(
              'general ',
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
                  onTap: () => Get.snackbar("settings", ""),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: () =>  Get.snackbar("notifications", "notifications not available"),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  onTap: () =>  Get.snackbar("language", "default language is english"),
                ),
                
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Security'),
                  onTap: () => _showFeatureNotAvailable(context),
                ),
                ListTile(
                  leading: const Icon(Icons.upgrade),
                  title: const Text('Upgrade'),
                  onTap: () => Get.snackbar("no updates", "no updates yet"),
                ),
                ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text('Logout'),
                  onTap: () => Get.toNamed('/login'),
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

