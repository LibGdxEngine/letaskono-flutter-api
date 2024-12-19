import 'package:flutter/material.dart';

class CircularText extends StatelessWidget {
  final String text;
  final double size;
  final Color borderColor;
  final double borderWidth;
  final TextStyle textStyle;

  const CircularText({
    Key? key,
    required this.text,
    this.size = 50, // Default size of the circle
    this.borderColor = Colors.blue, // Default border color
    this.borderWidth = 2, // Default border width
    this.textStyle = const TextStyle(fontSize: 16, color: Colors.black), // Default text style
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   border: Border.all(
      //     color: borderColor,
      //     width: borderWidth,
      //   ),
      // ),
      alignment: Alignment.center, // Center the text inside the circle
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
