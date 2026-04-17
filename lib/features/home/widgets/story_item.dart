import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final String imageUrl;
  final bool isSeen;

  const StoryItem({super.key, required this.imageUrl, required this.isSeen});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSeen
              ? null
              : const LinearGradient(
                  colors: [Colors.pink, Colors.orange, Colors.yellow],
                ),
          border: isSeen ? Border.all(color: Colors.grey, width: 2) : null,
        ),

        child: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
    );
  }
}
