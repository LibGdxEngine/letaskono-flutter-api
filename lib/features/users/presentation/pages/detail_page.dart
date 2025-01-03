import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letaskono_flutter/core/utils/ExpandingCircleProgress.dart';
import 'package:letaskono_flutter/features/users/data/models/AcceptanceRequest.dart';

import '../bloc/action_btn_bloc.dart';
import '../bloc/user_bloc.dart';

import '../widgets/CircularImageWithBorder.dart';
import '../../../../core/utils/CustomDialog.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailPage extends StatelessWidget {
  final String? userId; // Nullable to handle edge cases

  const DetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final actionsBloc = ActionBtnBloc();
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Invalid user ID')),
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
            String userStyle = "";
            if (userDetails.gender == "M") {
              if (userDetails.le7ya == "ملتحي") {
                userStyle = "assets/images/photo3.png";
              } else if (userDetails.le7ya == "لحية خفيفة") {
                userStyle = "assets/images/photo1.png";
              } else if (userDetails.le7ya == "أملس") {
                userStyle = "assets/images/photo2.png";
              }
            } else if (userDetails.gender == "F") {
              if (userDetails.hijab == "منتقبة سواد") {
                userStyle = "assets/images/wphoto1.png";
              } else if (userDetails.hijab == "منتقبة ألوان") {
                userStyle = "assets/images/photo_of_niqab_colored_woman.png";
              } else if (userDetails.hijab == "مختمرة") {
                userStyle = "assets/images/woman.png";
              } else if (userDetails.hijab == "طرح وفساتين") {
                userStyle = "assets/images/woman.png";
              } else {
                userStyle = "assets/images/woman.png";
              }
            }
            return BlocProvider(
              create: (context) => actionsBloc,
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.primary,
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
                      context
                          .read<UserBloc>()
                          .add(FetchUserDetailsEvent(userId!));
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
                      return ExpandingCircleProgress();
                    }
                    final requestStatus = userDetails.validRequest?.status;
                    int? receiverId, senderId;
                    if (userDetails.pkid.toString() ==
                        userDetails.validRequest?.senderPkid.toString()) {
                      receiverId = userDetails.validRequest?.senderPkid;
                      senderId = userDetails.validRequest?.receiverPkid;
                    } else {
                      receiverId = userDetails.validRequest?.receiverPkid;
                      senderId = userDetails.validRequest?.senderPkid;
                    }
                    Widget mainActionBtn = Transform.scale(
                      scale: 1.0,
                      child: FloatingActionButton(
                        heroTag: 'send',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: 'هل تريد إرسال طلب قبول ؟',
                                content: const Text(
                                    'طلب القبول يعني أنك موافق على المواصفات المبدئية لهذا الشخص'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => {
                                      userDetails.validRequest != null
                                          ? buildShowSnackBar(
                                              context, userDetails.validRequest)
                                          : actionsBloc.add(SendRequestEvent(
                                              userDetails.id!)),
                                      Navigator.pop(context, 'OK'),
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4B164C),
                                      // Darkest color
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('نعم'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Text(
                                      'إلغاء',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(
                                                  0.7)), // Accent color
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/send_icon.png",
                              width: 25,
                              height: 25,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );

                    if (requestStatus == "SENT") {
                      if (userDetails.pkid ==
                          userDetails.validRequest?.senderPkid.toString()) {
                        mainActionBtn = Transform.scale(
                          scale: 1.0,
                          child: FloatingActionButton(
                            heroTag: 'respond',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    title: 'هل تريد الاستجابة لطلب القبول ؟',
                                    content: const Text(
                                        'إذا قبلت هذا الطلب فستنتقل لمرحلة الأسئلة حيث يمكنك معرفة تفاصيل أكثر'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => {
                                          actionsBloc.add(AcceptRequestEvent(
                                              userDetails.validRequest!.id)),
                                          Navigator.pop(context, 'قبول'),
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF4B164C),
                                          // Darkest color
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('قبول'),
                                      ),
                                      TextButton(
                                        onPressed: () => {
                                          actionsBloc.add(RejectRequestEvent(
                                              userDetails.validRequest!.id)),
                                          Navigator.pop(context, 'رفض')
                                        },
                                        child: Text(
                                          'رفض',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(
                                                      0.7)), // Accent color
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.reply_all_outlined,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        mainActionBtn = Transform.scale(
                          scale: 1.0,
                          child: FloatingActionButton(
                            heroTag: 'respond',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                    title: 'في انتظار الرد على طلبك',
                                    content: const Text(
                                        'يجب أن تنتظر حتى يتم الرد على طلبك أو تنقضي مدة الطلب السابق قبل إرسال طلب جديد'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => {
                                          Navigator.pop(context, 'قبول'),
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF4B164C),
                                          // Darkest color
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('حسنا'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_clock_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    } else if (requestStatus == "ACCEPTED") {
                      if (userDetails.validRequest?.chatRoom?.state
                              .toLowerCase() ==
                          "open") {
                        mainActionBtn = Transform.scale(
                          scale: 1.0,
                          child: FloatingActionButton(
                            heroTag: 'chat',
                            onPressed: () {
                              Navigator.pushNamed(context, '/chat', arguments: {
                                'currentMessageCount': userDetails.validRequest
                                    ?.chatRoom?.currentUserMessageCount,
                                'roomId':
                                    userDetails.validRequest?.chatRoom?.id,
                                'currentUserState': userDetails
                                    .validRequest?.chatRoom?.currentUserState,
                                'otherUserState': userDetails
                                    .validRequest?.chatRoom?.otherUserState,
                                'senderId': senderId,
                                'receiverId': receiverId,
                              });
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (userDetails.validRequest?.chatRoom?.state
                              .toLowerCase() ==
                          "closed") {
                        mainActionBtn = Transform.scale(
                          scale: 1.0,
                          child: FloatingActionButton(
                            heroTag: 'no_more',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('لقد تم الرفض بينكما مسبقا')));
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.no_accounts_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (userDetails.validRequest?.chatRoom?.state
                              .toLowerCase() ==
                          "khetba") {
                        mainActionBtn = Transform.scale(
                          scale: 1.0,
                          child: FloatingActionButton(
                            heroTag: 'khetba',
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "/khetba", arguments: {
                                "roomId": userDetails.validRequest?.chatRoom?.id
                              });
                            },
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_outline,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                // White background
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary, // Border color
                                  width: 0.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(32.0),
                                // Circular radius
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.06), // Shadow color
                                    spreadRadius: 5, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: const Offset(
                                        0, 3), // Offset in x and y direction
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                    scale: 1,
                                    child: FloatingActionButton(
                                      heroTag: 'favourite',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              title: userDetails
                                                      .isUserInFollowingList!
                                                  ? 'هل تريد إلغاء حفظ الاستمارة ؟'
                                                  : 'هل تريد حفظ الاستمارة ؟',
                                              content: const Text(
                                                  'يمكنك الرجوع لقائمة المحفوظات في أي وقت'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () => {
                                                    userDetails
                                                            .isUserInFollowingList!
                                                        ? actionsBloc.add(
                                                            RemoveFromFavouritesEvent(
                                                                userDetails
                                                                    .code!))
                                                        : actionsBloc.add(
                                                            AddToFavouritesEvent(
                                                                userDetails
                                                                    .code!)),
                                                    Navigator.pop(
                                                        context, 'نعم'),
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF4B164C),
                                                    // Darkest color
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  child: const Text('نعم'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'إلغاء'),
                                                  child: Text(
                                                    'إلغاء',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(
                                                                0.7)), // Accent color
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            userDetails.isUserInFollowingList!
                                                ? Icons.star
                                                : Icons.star_outline,
                                            size: 30,
                                          ),
                                          // Text('Add', style: TextStyle(fontSize: 10),),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  mainActionBtn,
                                  const SizedBox(width: 32),
                                  Transform.scale(
                                    scale: 1.0,
                                    child: FloatingActionButton(
                                      heroTag: 'cancel',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialog(
                                              title: userDetails
                                                      .isUserInBlackList!
                                                  ? 'هل تريد إلفاء حظر هذا الشخص ؟'
                                                  : 'هل تريد حظر هذا الشخص ؟',
                                              content: userDetails
                                                      .isUserInBlackList!
                                                  ? const Text(
                                                      'إذا ألغيت حظر هذا الشخص فسيمكنه إرسال طلبات لك مجددا')
                                                  : const Text(
                                                      'إذا قمت بحظره فلن يستطيع إرسال طلبات قبول لك'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () => {
                                                    userDetails
                                                            .isUserInBlackList!
                                                        ? actionsBloc.add(
                                                            RemoveFromBlackListEvent(
                                                                userDetails
                                                                    .code!))
                                                        : actionsBloc.add(
                                                            AddToBlackListEvent(
                                                                userDetails
                                                                    .code!)),
                                                    Navigator.pop(
                                                        context, 'نعم'),
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF4B164C),
                                                    // Darkest color
                                                    foregroundColor:
                                                        Colors.white,
                                                  ),
                                                  child: const Text('نعم'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'إلغاء'),
                                                  child: Text(
                                                    'إلغاء',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(
                                                                0.7)), // Accent color
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            size: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          // Text('Add', style: TextStyle(fontSize: 10),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return <SliverAppBar>[
                      SliverAppBar(
                        expandedHeight: screenHeight * 0.3,
                        // Height of the header
                        floating: false,
                        pinned: true,
                        backgroundColor: Colors.transparent,
                        leading: innerBoxIsScrolled
                            ? BackButton(
                                color: Theme.of(context).colorScheme.primary)
                            : BackButton(
                                color: Theme.of(context).colorScheme.surface),
                        actions: innerBoxIsScrolled
                            ? []
                            : [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0x9fF8E7F6),
                                        Color(0xffF8E7F6),
                                        Color(0xffF8E7F6),
                                        Color(0xffF8E7F6),
                                        Color(0xffF8E7F6),
                                        Color(0x9FF8E7F6)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                    // Rounded corners
                                    border: Border.all(
                                      color: const Color(
                                          0xFFF8E7F6), // Border color
                                      width: 1, // Border thickness
                                    ),
                                  ),
                                  child: Text(
                                    '#${userDetails.code}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],

                        centerTitle: true,
                        forceMaterialTransparency: true,
                        clipBehavior: Clip.antiAlias,
                        automaticallyImplyLeading: true,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.parallax,
                          centerTitle: true,
                          title: innerBoxIsScrolled
                              ? null
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,

                                    borderRadius: BorderRadius.circular(28),
                                    // Rounded corners
                                    border: Border.all(
                                      color: const Color(
                                          0xFFF8E7F6), // Border color
                                      width: 1, // Border thickness
                                    ),
                                  ),
                                  child: Text(
                                    '${userDetails.maritalStatus} ${userDetails.le7ya ?? userDetails.hijab} ${userDetails.age} سنة',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF22172A), // Text color
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          background: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    // Rotate around the center of the SVG
                                    transform: Matrix4.rotationZ(3.14159),
                                    // 180 degrees in radians
                                    child: SvgPicture.asset(
                                      "assets/images/circles.svg",
                                      width: screenWidth,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 21,
                                  // Adjust this value to control spacing from AppBar
                                  left: (screenWidth - 124) / 2,
                                  // Center horizontally
                                  child: SizedBox(
                                    width: 124,
                                    height: 124,
                                    child: CircularImageWithThickBorder(
                                      imagePath: userStyle,
                                      isOnline: userDetails.isOnline!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ];
                  },
                  body: SizedBox(
                    height: screenHeight * 0.80,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28)),
                      child: SingleChildScrollView(
                        child: Card(
                          color: Theme.of(context).colorScheme.surface,
                          margin: const EdgeInsets.symmetric(vertical: 0.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28),
                                topRight: Radius.circular(28)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          // Ensure content respects the Card's borders
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "معلومات عامة",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    if(userDetails.isOnline != true)
                                      Column(
                                      children: [
                                        Text(
                                          'اخر ظهور',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        ),
                                        Text(
                                          timeago.format(userDetails.lastSeen!,
                                              locale: 'ar'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            message: 'الجنسية',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/nationality_icon.png',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    " ${userDetails.nationality}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            message: 'البلد, المحافظة',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/outlined_location_icon.png',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    " ${userDetails.country}, ${userDetails.state}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            message: 'الطول',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/height_icon.png',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    " ${userDetails.height} سم",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            message: 'الوزن',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/weight_icon.png',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    " ${userDetails.weight} كجم",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            message: 'لون البشرة',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/profile_icon.png',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    " بشرة ${userDetails.skinColor}",
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            message: 'المدينة/القرية',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/city_logo.png',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    " ${userDetails.city}",
                                                    overflow: TextOverflow.fade,
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                                const Text(
                                  "معلومات شخصية",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                Text(
                                  "تكلم عن نفسك:",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.aboutMe}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "الالتزام في الصلاة:",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.prayerFrequency}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "عدد الأجزاء التي تحفظها",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.memorizedQuranParts} بفضل الله",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "هل تحافظ على أذكار الصباح والمساء ؟",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.azkar}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "التعليم",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.educationLevel}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "الوظيفة",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.profession}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  "الحالة الاجتماعية",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.maritalStatus}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "عدد الأولاد الذكور",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.numberOfChildBoys}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "عدد الأولاد الإناث",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.numberOfChildGirls}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                userDetails.whoDoYouListenTo != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          Text(
                                            "لمن تسمع/تقرأ من المشايخ أو العلماء",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${userDetails.whoDoYouListenTo}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                userDetails.doAcquireKnowledge != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          Text(
                                            "هل تطلب العلم الشرعي ؟",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${userDetails.doAcquireKnowledge}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                userDetails.doYouRelateToHizb != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          Text(
                                            "هل تنتمي لأي جماعات أو أحزاب ؟",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${userDetails.doYouRelateToHizb}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 16),
                                Text(
                                  "ما هي المواصفات التي تريدها في زوجك ؟",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.lookingFor}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                userDetails.hobbies != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          Text(
                                            "كيف تقضي وقتك أو ما هي هواياتك ؟",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            userDetails.hobbies ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                userDetails.languagesSpoken != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          Text(
                                            "ما هي اللغات التي تتحدثها ؟",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${userDetails.languagesSpoken}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                userDetails.disabilities != null
                                    ? Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    Text(
                                      "هل تعاني من أي أمراض أو إعاقات ؟",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${userDetails.disabilities}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 16),
                                const Text(
                                  "معلومات عن الأسرة",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                userDetails.fatherAlive == true
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          Text(
                                            "ما هي وظيفة الوالد ؟",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${userDetails.fatherOccupation}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                userDetails.motherAlive == true
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 16),
                                          Text(
                                            "ما هي وظيفة الوالدة ؟",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${userDetails.motherOccupation}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 16),
                                Text(
                                  "عدد الإخوة الذكور ؟",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.numberOfBrothers}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "عدد الأخوات البنات ؟",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.numberOfSisters}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "كيف هي علاقتك مع أهلك وأسرتك ؟",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.relationWithFamily}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "هل توافقين على الزواج (الشرعي) بدون معاصي أو قائمة منقولات ؟",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  userDetails.youAcceptMarriageWithoutQaima == true ? "نعم, أوافق": "لا أقبل",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "هل يوافق ولي أمرك على الزواج (الشرعي) ؟",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.fatherAcceptMarriageWithoutQaima}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "هل ولي أمرك على علم بتسجيلك في هذا التطبيق ؟",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${userDetails.fatherKnowAboutThisWebsite}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else if (detailsState is UsersError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('رجوع'),
              ),
              body: const Center(child: Text('حصل خطأ!')),
            );
          } else if (detailsState is UserLoading) {
            return Scaffold(
              body: Center(child: ExpandingCircleProgress()),
            );
          }

          return const Scaffold(
            body: Center(child: Text('Unexpected state')),
          );
        },
      ),
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
