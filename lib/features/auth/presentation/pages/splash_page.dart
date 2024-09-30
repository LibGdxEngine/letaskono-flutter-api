import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/signup');
    });
    return Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.blueAccent,
      )),
    );
  }
}
