import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/profileSetup');
    });
    return const Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.blueAccent,
      )),
    );
  }
}
