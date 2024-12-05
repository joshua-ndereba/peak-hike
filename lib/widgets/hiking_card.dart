import 'package:flutter/material.dart';

class HikeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final String difficulty;
  final String duration;

  const HikeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.difficulty,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.asset(imageUrl),
          Text(title),
          Text('Rating: $rating'),
          Text('Difficulty: $difficulty'),
          Text('Duration: $duration'),
        ],
      ),
    );
  }
}