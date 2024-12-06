import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import 'UserCard.dart';

class UsersList extends StatefulWidget {
  final bool isFavourite;

  const UsersList({
    super.key,
    required this.isFavourite,
  });

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<UserBloc>();
    final state = bloc.state;

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        state is UsersLoaded &&
        state.hasMore) {
      widget.isFavourite
          ? bloc.add(FetchFavouritesEvent(page: state.currentPage + 1))
          : bloc.add(FetchUsersEvent(page: state.currentPage + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading && state is! UserLoadingMore) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UsersError) {
          return Center(child: Text(state.error));
        } else if (state is UsersLoaded || state is UserLoadingMore) {
          final users = state is UsersLoaded
              ? state.users
              : (state as UserLoadingMore).users;
          return RefreshIndicator(
            onRefresh: () async {
              context.read<UserBloc>().add(widget.isFavourite
                  ? FetchFavouritesEvent(
                      page: (state as UsersLoaded).currentPage,
                      isRefreshing: true,
                    )
                  : FetchUsersEvent(
                      page: (state as UsersLoaded).currentPage,
                      isRefreshing: true,
                    ));
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: users.length + (state is UserLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= users.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/userDetail',
                      arguments:
                          users[index].code, // Pass the 'id' as an argument
                    );
                  },
                  child: UserCard(user: users[index]),
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
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
