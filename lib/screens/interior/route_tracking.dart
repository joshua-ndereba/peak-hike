

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hike/screens/interior/home.dart';
import 'package:hike/screens/interior/profile.dart';
import 'package:hike/widgets/bottomnavigationbar.dart';

class RouteTrackingPage extends StatefulWidget {
  const RouteTrackingPage({super.key});

  @override
  _RouteTrackingPageState createState() => _RouteTrackingPageState();
}

class _RouteTrackingPageState extends State<RouteTrackingPage> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final List<LatLng> _points = [];
  LatLng? _lastKnownLocation;
  double _totalDistance = 0.0;
  DateTime? _startTime;
  Timer? _trackingTimer;
  StreamSubscription<Position>? _positionStream;
  bool _isTracking = false;
  Duration _elapsedTime = Duration.zero;
  final TextEditingController _hikeNameController = TextEditingController();
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
  }

  Future<void> _saveHikeData() async {
    if (username == null) return;

    final String hikeName = _hikeNameController.text.trim().isNotEmpty
        ? _hikeNameController.text
        : 'Hike';

    final hikeData = {
      'name': '$hikeName (${DateTime.now()})',
      'distance': _totalDistance,
      'elapsedTime': _elapsedTime.toString(),
      'route': _points.map((point) {
        return {'lat': point.latitude, 'lng': point.longitude};
      }).toList(),
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? hikesData = prefs.getString('hikes_$username');
    List<Map<String, dynamic>> hikes = [];
    if (hikesData != null) {
       ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hike data saved!')),
    );
      hikes = List<Map<String, dynamic>>.from(jsonDecode(hikesData));
    }

    hikes.add(hikeData);
    prefs.setString('hikes_$username', jsonEncode(hikes));

   
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _points.clear();
      _totalDistance = 0.0;
      _startTime = DateTime.now();
      _elapsedTime = Duration.zero;
    });

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2, // Update every 2 meters
      ),
    ).listen((Position position) {
      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      if (_lastKnownLocation != null) {
        double distance = Geolocator.distanceBetween(
          _lastKnownLocation!.latitude,
          _lastKnownLocation!.longitude,
          currentLocation.latitude,
          currentLocation.longitude,
        );

        if (distance >= 2) {
          _totalDistance += distance;
          _points.add(currentLocation);
        }
      } else {
        _points.add(currentLocation);
      }

      _lastKnownLocation = currentLocation;

      setState(() {
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: _points,
          color: Colors.blue,
          width: 5,
        ));
      });

      _mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation));
    });

    _trackingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime = DateTime.now().difference(_startTime!);
      });
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
    _trackingTimer?.cancel();
    setState(() {
      _isTracking = false;
    });

    _saveHikeData();
  }

  String _formatElapsedTime(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '${days.toString().padLeft(2, '0')}:'
        '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Tracking'),
        leading: null,
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Map Section
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-1.2921, 36.8219),
                    zoom: 10.0,
                  ),
                  polylines: _polylines,
                  onMapCreated: (controller) => _mapController = controller,
                ),
              ),
            ),
          ),
          // Control and Time/Distance Details
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                  ),
                ],
              ),
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _hikeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Hike Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isTracking ? null : _startTracking,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Start"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isTracking ? _stopTracking : null,
                        icon: const Icon(Icons.stop),
                        label: const Text("Stop"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Elapsed Time: ${_formatElapsedTime(_elapsedTime)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        screens: [
          const DashboardScreen(),
          const RouteTrackingPage(),
          ProfilePage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _trackingTimer?.cancel();
    _mapController?.dispose();
    _hikeNameController.dispose();
    super.dispose();
  }
}
