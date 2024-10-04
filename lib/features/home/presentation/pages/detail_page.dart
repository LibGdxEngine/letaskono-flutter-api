import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final int? userId; // Nullable to handle edge cases

  const DetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Invalid user ID')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('User $userId Details')),
      body: Center(
        child: Text('Details for User $userId'),
      ),
    );
  }
}
