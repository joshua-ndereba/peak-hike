import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for hikes',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search logic here
                // For example, filter hikes based on the search query
              },
            ),
            // Display search results here, e.g., a ListView of matching hikes
          ],
        ),
      ),
    );
  }
}