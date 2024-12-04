import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../widgets/UserCard.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(FetchUsersEvent()),
      child: Scaffold(
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UsersError) {
              return Center(child: Text(state.error));
            } else if (state is UsersLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<UserBloc>().add(FetchUsersEvent());
                },
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/userDetail',
                          arguments: user.code, // Pass the 'id' as an argument
                        );
                      },
                      child: UserCard(user: user),
                    );
                  },
                ),
              );
            } else if (state is UsersError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('...'));
            }
          },
        ),
      ),
    );
  }
}
