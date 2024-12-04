import 'package:flutter/material.dart';
import 'package:letaskono_flutter/features/users/domain/entities/user_entity.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;

  UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Code: ${user.code}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Education Level: ${user.educationLevel}'),
            Text('Profession: ${user.profession}'),
            Text('Age: ${user.age}'),
            Text('Height: ${user.height} cm'),
            Text('Weight: ${user.weight} kg'),
            Text('Country: ${user.weight}'),
            Text('Marital Status: ${user.maritalStatus}'),
            Text('Gender: ${user.gender}'),
            SizedBox(height: 8),
            Text(
              'Last Seen: ${user.lastSeen}',
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              'Date Joined: ${user.dateJoined}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
