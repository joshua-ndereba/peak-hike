/*import 'package:flutter/material.dart';

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const DestinationCard({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(imageUrl),
          Text(title),
        ],
      ),
    );
  }
}*/


import 'package:flutter/material.dart';

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  const DestinationCard({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to adjust the card size dynamically based on the screen width
    double cardWidth = MediaQuery.of(context).size.width * 0.6; // Adjust width to 60% of screen width

    return Card(
      elevation: 4.0, // Adds a subtle shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Margin around the card
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19.0), // Rounded corners to match the card
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover, // Ensures the image fills the card without distortion
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Align(
            alignment: Alignment.bottomLeft, // Align text at the bottom left
            child: Container(
              color: Colors.black.withOpacity(0.6), // Semi-transparent background for text
              padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 11.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                maxLines: 1, // Limit to one line of text
              ),
            ),
          ),
        ),
      ),
    );
  }
}
