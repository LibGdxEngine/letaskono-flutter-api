import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../widgets/FilterBottomSheet.dart';
import '../widgets/UsersList.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = UserBloc()..add(FetchUsersEvent());
    void _showFilterModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FilterBottomSheet(userBloc);
        },
      );
    }

    return BlocProvider(
      create: (context) => userBloc,
      child: Scaffold(
        body: const UsersList(
          key: ValueKey(false),
          isFavourite: false,
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1, // Adds slight elevation for a floating effect
          focusColor: Colors.white,
          mini: true,
          hoverColor: const Color(0x50DD88CF),
          backgroundColor: const Color(0xFFDD88CF),
          onPressed: () => _showFilterModal(context),
          child: Transform.rotate(
            angle: 90 * (3.14159265359 / 180), // Convert 90 degrees to radians
            child: Image.asset(
              "assets/images/icon_configurations.png",
              width: 35, // Adjust size to fit nicely in the circle
              height: 40,
              color: Colors.white,
              fit: BoxFit.contain, // Ensures the image fits well inside the button
            ),
          ),
        ),
      ),
    );
  }
}
