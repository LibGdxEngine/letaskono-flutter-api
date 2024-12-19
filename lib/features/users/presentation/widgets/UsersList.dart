import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/ExpandingCircleProgress.dart';
import '../bloc/user_bloc.dart';
import 'GenderToggle.dart';
import 'MatchCard.dart';

class UsersList extends StatefulWidget {
  final bool isFavourite;

  const UsersList({
    Key? key,
    required this.isFavourite,
  }) : super(key: key);

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
        if (state is UserLoading ) {
          return Center(child: ExpandingCircleProgress());
        } else if (state is UsersLoaded) {
          var genderSaved =
              GetIt.instance<SharedPreferences>().getString("filter_gender") ??
                  'F';
          var maleIsSelected = genderSaved == "M" ? true : false;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(widget.isFavourite
                    ? FetchFavouritesEvent(
                        page: (state as UsersLoaded).currentPage,
                        isRefreshing: true,
                      )
                    : RefreshFetchUsersEvent(
                        isRefreshing: true,
                      ));
              },
              child: Column(
                children: [
                  Visibility(
                    visible: !widget.isFavourite,
                    child: GenderToggle(
                      isMaleSelected: maleIsSelected,
                      onChange: (isMaleSelected) => {
                        maleIsSelected = isMaleSelected,
                        GetIt.instance<SharedPreferences>().setString(
                            "filter_gender", isMaleSelected ? "M" : "F"),
                        context.read<UserBloc>().add(
                              ApplyFiltersEvent(
                                gender: isMaleSelected ? "M" : "F",
                              ),
                            ),
                      },
                    ),
                  ),
                  Expanded(
                    child: state.users.isNotEmpty
                        ? GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // Number of cards per row
                              crossAxisSpacing: 20,
                              // Horizontal spacing between cards
                              mainAxisSpacing: 20,
                              // Vertical spacing between cards
                              childAspectRatio:
                                  0.7, // Adjust aspect ratio for card size
                            ),
                            itemCount: state.users.length,
                            itemBuilder: (context, index) {
                              final user = state.users[index];
                              String userStyle = "";
                              if (user.gender == "M") {
                                if (user.le7ya == "ملتحي") {
                                  userStyle = "assets/images/photo3.png";
                                } else if (user.le7ya == "لحية خفيفة") {
                                  userStyle = "assets/images/photo1.png";
                                } else if (user.le7ya == "أملس") {
                                  userStyle = "assets/images/photo2.png";
                                }
                              } else if (user.gender == "F") {
                                if (user.hijab == "منتقبة سواد") {
                                  userStyle = "assets/images/wphoto1.png";
                                } else if (user.hijab == "منتقبة ألوان") {
                                  userStyle =
                                      "assets/images/photo_of_niqab_colored_woman.png";
                                } else if (user.hijab == "مختمرة") {
                                  userStyle = "assets/images/wphoto3.png";
                                } else if (user.hijab == "طرح وفساتين") {
                                  userStyle = "assets/images/wphoto4.png";
                                }
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/userDetail',
                                    arguments: state.users[index]
                                        .code, // Pass the 'id' as an argument
                                  );
                                },
                                child: MatchCard(
                                  imageUrl: userStyle,
                                  userCode: user.code,
                                  styleOfPerson: user.gender == "M"
                                      ? user.le7ya
                                      : user.hijab,
                                  maritalStatus: user.maritalStatus,
                                  age: user.age,
                                  nationality: user.nationality,
                                  stateWhereLive: user.state,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: widget.isFavourite
                                ? const Text("ليس هناك محفوظات")
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          size: 24,
                                          Icons.filter_alt_off_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const Text("ليس هناك مستخدمين"),
                                      ],
                                    ),
                                  ),
                          ),
                  ),
                ],
              ),
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
