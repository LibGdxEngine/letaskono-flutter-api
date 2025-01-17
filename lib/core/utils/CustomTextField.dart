import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String prefexText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? preIconPadding;
  final int? maxLines;
  final String? topText;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.prefexText = "",
    this.onChanged,
    this.prefixIcon,
    this.maxLines = 1,
    this.suffixIcon,
    this.preIconPadding = 8,
    this.topText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define padding, border radius, and font size based on the screen size
    double contentPaddingVertical = screenHeight * 0.02; // 2% of screen height
    double contentPaddingHorizontal = screenWidth * 0.05; // 5% of screen width
    double borderRadiusValue = screenWidth * 0.05; // 5% of screen width
    double fontSize = screenWidth * 0.04; // 4% of screen width for font size

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: topText != null ? Text(topText!) : null,
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: onChanged,
            validator: validator,
            maxLines: maxLines,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: hintText,
              prefixText: prefexText,
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontFamily: 'NotoKufiArabic',
                fontSize: fontSize, // Responsive font size for hint text
              ),
              filled: false,
              // Background color
              contentPadding: EdgeInsets.symmetric(
                vertical: contentPaddingVertical, // Adjust padding dynamically
                horizontal:
                    contentPaddingHorizontal, // Adjust horizontal padding
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                // Responsive border radius
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Focused border color
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Error border color
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary, // Default border color
                  width: 1.5,
                ),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(preIconPadding!),
                child: prefixIcon,
              ),
              suffixIcon: suffixIcon,
            ),
            style: TextStyle(
              fontFamily: 'NotoKufiArabic',
              fontSize: fontSize, // Responsive font size for text input
              color: Color(0xFF333333), // Text color
            ),
          ),
        ],
      ),
    );
  }
}
