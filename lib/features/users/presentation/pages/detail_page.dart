import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:letaskono_flutter/core/utils/confirmation_dialog.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_page.dart';
import 'package:letaskono_flutter/features/users/data/models/AcceptanceRequest.dart';

import '../bloc/action_btn_bloc.dart';
import '../bloc/user_bloc.dart';
import 'package:letaskono_flutter/features/users/domain/entities/UserDetailsEntity.dart';

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
        builder: (context, detailsState) {
          if (detailsState is UserDetailsLoaded) {
            final userDetails = detailsState.user;
            return BlocProvider(
              create: (context) => ActionBtnBloc(),
              child: Scaffold(
                appBar: AppBar(title: Text('User ${userDetails.code} Details')),
                floatingActionButton:
                    BlocConsumer<ActionBtnBloc, ActionBtnState>(
                  listener: (context, state) {
                    if (state is RequestSentFailed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.reason)),
                      );
                    } else if (state is RequestSentSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is AddToFavouritesSuccess) {
                      detailsState.user.isUserInFollowingList = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is RemoveFromFavouritesSuccess) {
                      detailsState.user.isUserInFollowingList = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is AddToBlockListSuccess) {
                      detailsState.user.isUserInBlackList = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is RemoveFromBlockListSuccess) {
                      detailsState.user.isUserInBlackList = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is RequestAcceptedSuccess) {
                      detailsState.user.validRequest?.status = "ACCEPTED";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                    } else if (state is RequestRejectedSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.result)),
                      );
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is RequestSentLoading) {
                      return CircularProgressIndicator();
                    }
                    return SpeedDial(
                      direction: SpeedDialDirection.up,
                      animatedIcon: AnimatedIcons.menu_close,
                      overlayColor: Colors.black,
                      overlayOpacity: 0.5,
                      switchLabelPosition: true,
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      children: [
                        buildRequestsButton(detailsState.user, context),
                        SpeedDialChild(
                          child: Icon(
                            userDetails.isUserInFollowingList!
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: Colors.white,
                          ),
                          label: userDetails.isUserInFollowingList!
                              ? 'إزالة من المحفوظات'
                              : 'حفظ الاستمارة',
                          backgroundColor: Colors.lightBlue,
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
                          child: Icon(
                            userDetails.isUserInBlackList!
                                ? Icons.block_outlined
                                : Icons.no_accounts,
                            color: Colors.white,
                          ),
                          label: userDetails.isUserInBlackList!
                              ? 'إزالة الحظر'
                              : "حظر الاستمارة",
                          backgroundColor: Colors.lightBlue,
                          onTap: () => userDetails.isUserInBlackList!
                              ? BlocProvider.of<ActionBtnBloc>(context).add(
                                  RemoveFromBlackListEvent(userDetails.code!))
                              : BlocProvider.of<ActionBtnBloc>(context)
                                  .add(AddToBlackListEvent(userDetails.code!)),
                        ),
                      ],
                    );
                  },
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
          } else if (detailsState is UsersError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('حصل خطأ!')),
            );
          } else if (detailsState is UserLoading) {
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

  SpeedDialChild buildRequestsButton(
      UserDetailsEntity userDetails, BuildContext context) {
    final requestStatus = userDetails.validRequest?.status;
    int? senderUserId, receiverUserId;
    if (userDetails.pkid.toString() ==
        userDetails.validRequest?.senderPkid.toString()) {
      senderUserId = userDetails.validRequest?.senderPkid;
      receiverUserId = userDetails.validRequest?.receiverPkid;
    } else {
      senderUserId = userDetails.validRequest?.receiverPkid;
      receiverUserId = userDetails.validRequest?.senderPkid;
    }

    if (requestStatus == "SENT") {
      if (userDetails.pkid == userDetails.validRequest?.senderPkid.toString()) {
        return SpeedDialChild(
          child: const Icon(
            Icons.reply_all_outlined,
            color: Colors.white,
          ),
          label: 'استجابة للطلب',
          backgroundColor: Colors.lightBlue,
          onTap: () async {
            final result = await ConfirmationDialog.show(
              context,
              title: "استجابة لطلب القبول",
              message: "هل تريد فعلا قبول هذا الطلب ؟",
              dismissible: false,
              actions: [
                TextButton(
                  onPressed: () => {
                    BlocProvider.of<ActionBtnBloc>(context)
                        .add(RejectRequestEvent(userDetails.validRequest!.id)),
                    Navigator.of(context).pop(false)
                  },
                  child: const Text("رفض الطلب"),
                ),
                TextButton(
                  onPressed: () => {
                    BlocProvider.of<ActionBtnBloc>(context)
                        .add(AcceptRequestEvent(userDetails.validRequest!.id)),
                    // reload the page for refresh state
                    Navigator.popAndPushNamed(context, "/userDetail",
                        arguments: userDetails.code),
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("تم قبول الطلب بنجاح")),
                    ),
                  },
                  child: const Text("قبول الطلب"),
                ),
              ],
            );

            // if (result == true) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("تم قبول الطلب بنجاح")),
            //   );
            // } else {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("تم رفض هذا الطلب")),
            //   );
            // }
          },
        );
      }
      return SpeedDialChild(
        child: const Icon(
          Icons.lock_clock_outlined,
          color: Colors.white,
        ),
        label: 'في انتظار الرد على طلبك',
        backgroundColor: Colors.lightBlue,
        onTap: () => {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'يجب أن تنتظر حتى يتم الرد على طلبك أو تمر 24 ساعة قبل إرسال طلب جديد')),
          )
        },
      );
    } else if (requestStatus == "ACCEPTED") {
      return SpeedDialChild(
        child: const Icon(
          Icons.chat_bubble_outline,
          color: Colors.white,
        ),
        label: 'دخول مرحلة الأسئلة',
        backgroundColor: Colors.lightBlue,
        onTap: () => {
          Navigator.pushNamed(context, '/chat', arguments: {
            'roomId': userDetails.validRequest?.chatRoom?.id,
            'senderId': senderUserId,
            'receiverId': receiverUserId,
          }),
        },
      );
    }
    return SpeedDialChild(
      child: const Icon(
        Icons.send,
        color: Colors.white,
      ),
      label: 'إرسال طلب قبول',
      backgroundColor: Colors.lightBlue,
      onTap: () => {
        userDetails.validRequest != null
            ? buildShowSnackBar(context, userDetails.validRequest)
            : BlocProvider.of<ActionBtnBloc>(context)
                .add(SendRequestEvent(userDetails.id!))
      },
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildShowSnackBar(
      BuildContext context, AcceptanceRequest? validRequest) {
    String message = "";
    if (validRequest?.status == "SENT") {
      message = "لقد أرسلت طلب قبول مسبقا, انتظر حتى تنتهي المهلة";
    } else if (validRequest?.status == "ACCEPTED") {
      message = "لقد قبلت الطلب مسبقا";
    } else if (validRequest?.status == "REJECTED") {
      message = "لقد رفضت الطلب مسبقا";
    } else if (validRequest?.status == "TIMED OUT") {
      message = "لقد انتهت صلاحية هذا الطلب مسبقا";
    }
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
        style: const TextStyle(
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
