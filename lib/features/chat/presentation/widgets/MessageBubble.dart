import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isBold;
  final bool? isSender;

  const MessageBubble({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.isBold = false,
    this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomRight: isSender == null
              ? const Radius.circular(16)
              : isSender == true
                  ? const Radius.circular(0)
                  : const Radius.circular(16),
          bottomLeft: isSender == null
              ? const Radius.circular(16)
              : isSender == true
                  ? const Radius.circular(16)
                  : const Radius.circular(0),
          topRight: const Radius.circular(16),
          topLeft: const Radius.circular(16),
        ),
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
