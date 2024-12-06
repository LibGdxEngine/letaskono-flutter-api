import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../widgets/UserCard.dart';
import '../widgets/UsersList.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(FetchUsersEvent()),
      child: const Scaffold(
        body: UsersList(isFavourite: false,),
      ),
    );
  }
}


