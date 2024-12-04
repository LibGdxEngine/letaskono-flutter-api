import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../bloc/action_btn_bloc.dart';
import '../bloc/user_bloc.dart';

class DetailPage extends StatelessWidget {
  final String? userId; // Nullable to handle edge cases

  const DetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Invalid user ID')),
      );
    }

    return BlocProvider(
      create: (context) => UserBloc()..add(FetchUserDetailsEvent(userId!)),
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UsersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserDetailsLoaded) {
            final userDetails = state.user;
            return BlocProvider(
              create: (context) => ActionBtnBloc(),
              child: Scaffold(
                appBar: AppBar(title: Text('User ${userDetails.code} Details')),
                floatingActionButton:
                    BlocListener<ActionBtnBloc, ActionBtnState>(
                  listener: (context, state) {
                    if (state is RequestSentFailed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.reason)),
                      );
                    } else if (state is AddToFavouritesSuccess) {
                      userDetails.isUserInFollowingList = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is RemoveFromFavouritesSuccess) {
                      userDetails.isUserInFollowingList = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is AddToBlockListSuccess) {
                      userDetails.isUserInBlackList = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is RemoveFromBlockListSuccess) {
                      userDetails.isUserInBlackList = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    }
                  },
                  child: BlocBuilder<ActionBtnBloc, ActionBtnState>(
                    builder: (context, state) {
                      if (state is RequestSentLoading) {
                        return CircularProgressIndicator();
                      }
                      return SpeedDial(
                        animatedIcon: AnimatedIcons.menu_close,
                        overlayColor: Colors.black,
                        overlayOpacity: 0.5,
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        children: [
                          SpeedDialChild(
                            child: Icon(Icons.send),
                            label: 'Add Item',
                            backgroundColor: Colors.green,
                            onTap: () => {
                              userDetails.isUserSentMeValidRequest!
                                  ? ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'لقد تلقيت طلبا من هذا الشخص\n'
                                              ' تفقد قائمة الطلبات الخاصة بك')),
                                    )
                                  : BlocProvider.of<ActionBtnBloc>(context)
                                      .add(SendRequestEvent(userDetails.id!))
                            },
                          ),
                          SpeedDialChild(
                            child: Icon(Icons.favorite_outline),
                            label: 'Edit Item',
                            backgroundColor: Colors.orange,
                            onTap: () => {
                              userDetails.isUserInFollowingList!
                                  ? BlocProvider.of<ActionBtnBloc>(context).add(
                                      RemoveFromFavouritesEvent(
                                          userDetails.code!))
                                  : BlocProvider.of<ActionBtnBloc>(context).add(
                                      AddToFavouritesEvent(userDetails.code!))
                            },
                          ),
                          SpeedDialChild(
                            child: Icon(Icons.delete),
                            label: 'Delete Item',
                            backgroundColor: Colors.red,
                            onTap: () => userDetails.isUserInBlackList!
                                ? BlocProvider.of<ActionBtnBloc>(context).add(
                                    RemoveFromBlackListEvent(userDetails.code!))
                                : BlocProvider.of<ActionBtnBloc>(context).add(
                                    AddToBlackListEvent(userDetails.code!)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                body: CustomScrollView(
                  slivers: [
                    _buildStickyHeader('Personal Information'),
                    _buildListItems([
                      'Gender: ${userDetails.gender}',
                      'Age: ${userDetails.age ?? 'N/A'}',
                      'height: ${userDetails.height ?? 'N/A'}',
                      'weight: ${userDetails.weight ?? 'N/A'}',
                      'skin: ${userDetails.skinColor ?? 'N/A'}',
                    ]),
                    _buildStickyHeader('Profile Details'),
                    _buildListItems([
                      'Education Level: ${userDetails.educationLevel ?? 'N/A'}',
                      'Profession: ${userDetails.profession ?? 'N/A'}',
                      'Marital Status: ${userDetails.maritalStatus ?? 'N/A'}',
                      'About Me: ${userDetails.aboutMe ?? 'N/A'}',
                    ]),
                    _buildStickyHeader('Family Information'),
                    _buildListItems([
                      'Father Alive: ${userDetails.fatherAlive! ? 'Yes' : 'No'}',
                      'Mother Alive: ${userDetails.motherAlive! ? 'Yes' : 'No'}',
                      'Number of Brothers: ${userDetails.numberOfBrothers}',
                      'Number of Sisters: ${userDetails.numberOfSisters}',
                    ]),
                    _buildStickyHeader('Preferences'),
                    _buildListItems([
                      if (userDetails.preferredCountry != null &&
                          userDetails.preferredCountry!.isNotEmpty)
                        'Preferred Country: ${userDetails.preferredCountry}',
                      if (userDetails.hobbies != null &&
                          userDetails.hobbies!.isNotEmpty)
                        'Hobbies: ${userDetails.hobbies}',
                      'Looking For: ${userDetails.gender ?? 'N/A'}',
                    ]),
                  ],
                ),
              ),
            );
          } else if (state is UsersError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(child: Text('حصل خطأ!')),
            );
          } else if (state is UserLoading) {
            return Scaffold(
              appBar: AppBar(title: Text('User $userId Details')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text('User $userId Details')),
            body: const Center(child: Text('Unexpected state')),
          );
        },
      ),
    );
  }
}

// Sticky Header Builder
Widget _buildStickyHeader(String title) {
  return SliverPersistentHeader(
    pinned: true,
    delegate: _StickyHeaderDelegate(title: title),
  );
}

// List Items Builder
Widget _buildListItems(List<String> items) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        return ListTile(
          title: Text(items[index]),
        );
      },
      childCount: items.length,
    ),
  );
}

// Delegate for Sticky Header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;

  _StickyHeaderDelegate({required this.title});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Background color for the sticky header
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
