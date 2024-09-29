import 'package:flutter/material.dart';
import 'package:letaskono_flutter/features/home/presentation/pages/detail_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: ListView.builder(
        itemCount: 10, // Replace with dynamic data later
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('User $index'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: index, // Ensure the 'index' is passed correctly here
              );
            },
          );
        },
      ),
    );
  }
}
