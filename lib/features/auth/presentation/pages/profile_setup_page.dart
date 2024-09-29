import 'package:flutter/material.dart';

class ProfileSetupPage extends StatelessWidget {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complete Your Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: ageController,
              decoration: InputDecoration(hintText: 'Age'),
            ),
            TextField(
              controller: genderController,
              decoration: InputDecoration(hintText: 'Gender'),
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(hintText: 'Bio'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle sending profile data to the admin
                Navigator.pushNamed(context, '/home');
              },
              child: Text('Submit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
