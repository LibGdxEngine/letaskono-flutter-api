import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: 10, // Replace with dynamic data later
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('User $index'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/profileSetup',
                arguments: index, // Ensure the 'index' is passed correctly here
              );
            },
          );
        },
      ),
    );
  }
}
