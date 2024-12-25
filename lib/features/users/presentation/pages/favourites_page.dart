import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/features/users/presentation/widgets/UsersList.dart';

import '../bloc/user_bloc.dart';
import '../widgets/UserCard.dart';

class FavouritesList extends StatelessWidget {
  const FavouritesList({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = UserBloc();
    return BlocProvider(
      create: (context) => userBloc..add(FetchFavouritesEvent()),
      child: Scaffold(
        body: SafeArea(
            child: UsersList(
          isFavourite: true,
          userBloc: userBloc,
        )),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UsersError) {
          return Center(child: Text(state.error));
        } else if (state is UsersLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<UserBloc>().add(FetchFavouritesEvent());
            },
            child: state.users.isNotEmpty
                ? ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/userDetail',
                            arguments:
                                user.code, // Pass the 'id' as an argument
                          );
                        },
                        child: UserCard(user: user),
                      );
                    },
                  )
                : const Center(
                    child: Text("ليس هناك محفوظات"),
                  ),
          );
        } else if (state is UsersError) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return Container(
          child: Text('data'),
        );
      },
    );
  }
}
