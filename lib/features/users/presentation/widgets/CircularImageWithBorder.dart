import 'package:flutter/material.dart';

class CircularImageWithThickBorder extends StatelessWidget {
  final String imagePath;
  final bool isOnline;

  const CircularImageWithThickBorder(
      {super.key, required this.imagePath, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular Border
          Container(
            width: 124, // Outer diameter (includes border thickness)
            height: 124,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isOnline ? Colors.green : Colors.grey, // Border color
                width: 4, // Border thickness
              ),
            ),
          ),
          // Circular Image
          Stack(children: [
            Center(
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  // Replace with your asset path
                  width: 108, // Image diameter
                  height: 108,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 300, // Same height as the image
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, // Start at the bottom
                  end: Alignment.bottomCenter, // End at the top
                  colors: [
                    Color(0x004B164C),
                    // 4B164C with 0% opacity (transparent)
                    Color(0xbf4B164C),
                    // 4B164C with 100% opacity
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
