import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String icon; // Add an IconData for the icon
  final Color iconBackgroundColor; // Background color for the icon

  CustomButton({
    required this.text,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    required this.icon, // Initialize icon
    required this.iconBackgroundColor, // Initialize icon background color
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define padding, corner radius, and font size based on the screen size
    double paddingVerticalValue = screenHeight * 0.02; // 5% of screen width
    double paddingHorizontalValue = screenWidth * 0.03; // 5% of screen width
    double borderRadiusValue = screenWidth * 0.09; // 8% of screen width
    double fontSize = screenWidth * 0.04; // 5% of screen width

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                borderRadiusValue), // Responsive border radius
          ),
          padding: EdgeInsets.symmetric(
            vertical: paddingVerticalValue,
            horizontal: paddingHorizontalValue,
          ),
          textStyle: TextStyle(
            fontFamily: 'NotoKufiArabic',
            fontSize: fontSize, // Responsive font size
          ),
        ),
        child: Row(
          children: [
            // Spacer to push the text to the center
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            const SizedBox(width: 0), // Space between the text and icon
            const Spacer(),
            // Icon in a circular background, placed on the right
            Container(
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle, // Circular background for the icon
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset(
                  icon,
                  width: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
