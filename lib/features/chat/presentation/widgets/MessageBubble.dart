import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isBold;

  const MessageBubble({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}