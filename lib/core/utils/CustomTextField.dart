import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:  TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontFamily: 'NotoKufiArabic',
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.inversePrimary, // Background color
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16, // Adjust padding
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
            borderSide:  BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:  BorderSide(
              color: Theme.of(context).colorScheme.primary, // Focused border color
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:  BorderSide(
              color: Theme.of(context).colorScheme.primary, // Error border color
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:  BorderSide(
              color: Theme.of(context).colorScheme.secondary, // Default border color
              width: 1.5,
            ),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        style: const TextStyle(
          fontFamily: 'NotoKufiArabic',
          fontSize: 16, // Adjust font size for readability
          color: Color(0xFF333333), // Text color
        ),
      ),
    );
  }
}
