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
          onPressed: () => _showFilterModal(context),
          child: const Icon(Icons.filter_alt),
        ),
      ),
    );
  }
}
