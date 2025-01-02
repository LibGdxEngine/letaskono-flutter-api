import 'dart:ui';

import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String imageUrl;
  final String userCode;
  final String styleOfPerson;
  final String maritalStatus;
  final int age;
  final String nationality;
  final String stateWhereLive;
  final bool isOnline;
  final bool visitedBefore;

  const UserCard({
    super.key,
    required this.imageUrl,
    required this.userCode,
    required this.styleOfPerson,
    required this.maritalStatus,
    required this.age,
    required this.nationality,
    required this.stateWhereLive,
    required this.isOnline,
    required this.visitedBefore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240, // Card width
      padding: const EdgeInsets.all(4), // Padding around the card
      decoration: BoxDecoration(
        color: visitedBefore
            ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
            : const Color(0xffDD88CF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        // Rounded corners for the image
        child: Stack(
          children: [
            // Background Image
            Stack(
              children: [
                Image.asset(
                  imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                        Color(0xFF4B164C),
                        // 4B164C with 100% opacity
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Match Percentage (Top Center)
            Positioned(
              top: -4,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                  color: Color(0xffDD88CF),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
                child: Text(
                  userCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),

            // Distance (Top Center, under match percentage)
            Positioned(
              bottom: 55,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  // Clip the child to avoid blur overflow
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    // Blur intensity
                    child: Container(
                      width: 100,
                      // Fixed width
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x004B164C), // 4B164C with 0% opacity
                            Color(0xFF4B164C), // 4B164C with 100% opacity
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          // Border
                          color: Theme.of(context)
                              .colorScheme
                              .secondary, // Border color DD88CF
                          width: 1,
                        ),
                      ),
                      child: Text(
                        styleOfPerson,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // Center horizontally
                children: [
                  // Green Circle Indicator
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Space between text and green circle
                  const SizedBox(width: 8),
                  // Name and Age Text
                  Text(
                    "$maritalStatus, $age",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Location (Centered Horizontally at Bottom)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/nationality_icon.png",
                        width: 10,
                        height: 10,
                      ),
                      Text(
                        " ${nationality.toUpperCase()}",
                        textAlign: TextAlign.center, // Center the text itself
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/outlined_location_icon.png",
                        width: 10,
                        height: 10,
                      ),
                      Text(
                        " ${stateWhereLive.toUpperCase()}",
                        textAlign: TextAlign.center, // Center the text itself
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
