

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hike/screens/interior/profile.dart';
import 'package:hike/screens/interior/route_tracking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hike/widgets/destination_card.dart';
import 'package:hike/widgets/bottomnavigationbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> _allHikes = [];
  bool _isLoading = true;
  final List<Map<String, dynamic>> _userHikes = [];
  List<Map<String, dynamic>> _filteredHikes = [];
  
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllHikes();
  }

  Future<void> _fetchAllHikes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final hikeKeys = allKeys.where((key) => key.startsWith('hikes_')).toList();

      List<Map<String, dynamic>> allHikes = [];
      for (String key in hikeKeys) {
        final String? hikesData = prefs.getString(key);
        if (hikesData != null) {
          final List<dynamic> data = jsonDecode(hikesData);
          allHikes.addAll(List<Map<String, dynamic>>.from(data));
        }
      }

      setState(() {
        _allHikes = allHikes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

void _filterHikes() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHikes = _userHikes.where((hike) {
        final name = hike['name'].toString().toLowerCase();
        final date = hike['date'].toString().toLowerCase(); // Ensure 'date' field exists in hikes data
        return name.contains(query) || date.contains(query);
      }).toList();
    });
  }

  Future<void> _deleteHike(int index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final allKeys = prefs.getKeys();
      final hikeKeys = allKeys.where((key) => key.startsWith('hikes_')).toList();

      for (String key in hikeKeys) {
        final String? hikesData = prefs.getString(key);
        if (hikesData != null) {
          final List<dynamic> data = jsonDecode(hikesData);
          if (index < data.length) {
            data.removeAt(index);
            prefs.setString(key, jsonEncode(data));
            break;
          } else {
            index -= data.length;
          }
        }
      }

      setState(() {
        _allHikes.removeAt(index);
      });
    } catch (e) {
      print('Error while deleting hike: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PEAK', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image with a rounded container
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/featured1.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Search Bar with rounded border and icon
                    /*TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search hikes by name or date',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),*/

                    const SizedBox(height: 16.0),

                    // Section header with a more modern font style
                    const Text(
                      'Popular Destinations',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Horizontally scrollable destinations
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          DestinationCard(
                            imageUrl: 'assets/images/featured2.jpeg',
                            title: 'Yosemite National Park',
                          ),
                          DestinationCard(
                            imageUrl: 'assets/images/featured3.jpeg',
                            title: 'Glacier National Park',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Section for All Saved Hikes
                    const Text(
                      'Your Hikes',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Conditional rendering of hikes or a message
                    _allHikes.isEmpty
                        ? const Center(
                            child: Text(
                              'No hikes recorded yet.',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _allHikes.length,
                            itemBuilder: (context, index) {
                              final hike = _allHikes[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hike['name'],
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        children: [
                                          Text(
                                            'Distance: ${(hike['distance'] / 1000).toStringAsFixed(2)} km',
                                            style: const TextStyle(fontSize: 16.0),
                                          ),
                                          const Spacer(),
                                          Text(
                                            'Time: ${hike['elapsedTime']}',
                                            style: const TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blueAccent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              _showHikeRoute(hike);
                                            },
                                            child: const Text(
                                              'View Route',
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              _deleteHike(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        screens: [
          const DashboardScreen(),
          const RouteTrackingPage(),
          ProfilePage(),
        ],
      ),
    );
  }

  // Show the route of a selected hike on a new screen
  void _showHikeRoute(Map<String, dynamic> hike) {
    List<LatLng> route = (hike['route'] as List).map((e) {
      return LatLng(e['lat'], e['lng']);
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HikeRoutePage(route: route),
      ),
    );
  }
}

class HikeRoutePage extends StatelessWidget {
  final List<LatLng> route;

  const HikeRoutePage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hike Route'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: route.isNotEmpty ? route[0] : const LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.0,
        ),
        polylines: {
          Polyline(
            polylineId: const PolylineId('hikeRoute'),
            points: route,
            color: Colors.blue,
            width: 5,
          ),
        },
        markers: route.isNotEmpty
            ? {
                Marker(
                  markerId: const MarkerId('start'),
                  position: route[0],
                ),
                Marker(
                  markerId: const MarkerId('end'),
                  position: route.last,
                ),
              }
            : {},
      ),
    );
  }
}
