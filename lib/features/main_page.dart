import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:letaskono_flutter/core/utils/AppDrawer.dart';
import 'package:letaskono_flutter/core/utils/CustomDialog.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_list_main.dart';
import 'package:letaskono_flutter/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:letaskono_flutter/features/requests/presentation/pages/requests_page.dart';
import 'package:letaskono_flutter/features/users/presentation/bloc/user_bloc.dart';
import 'package:letaskono_flutter/features/users/presentation/pages/favourites_page.dart';
import 'package:letaskono_flutter/features/users/presentation/pages/home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late UserBloc _userBloc;
  late NotificationBloc _notificationBloc;
  int _selectedIndex = 0; // State to manage selected index

  // List of screens for navigation
  final List<Widget> _screens = [
    const UsersPage(),
    const RequestsList(),
    const FavouritesList(),
    const ChatListMain(),
    // Center(child: Text('المقالات')),
  ];

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(); // Initialize your BLoC
    _notificationBloc = NotificationBloc();
    _userBloc.add(SetOnlineEvent());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _userBloc.close();
    _notificationBloc.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive || // When app goes to background
        state == AppLifecycleState.paused) {
      _userBloc.add(SetOfflineEvent());
    } else if (state == AppLifecycleState.resumed) {
      _userBloc.add(SetOnlineEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'لتسكنوا',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          const SizedBox(
            width: 8,
          ),
          BlocProvider(
            create: (context) =>
                _notificationBloc..add(FetchUnreadNotificationsCountEvent()),
            child: BlocConsumer<NotificationBloc, NotificationState>(
              listener: (context, state) {
                if (state is UnreadNotificationsCountFetched) {}
              },
              builder: (context, state) {
                final textCount =
                    state is UnreadNotificationsCountFetched && state.count > 0
                        ? Text(
                            state.count.toString(),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          )
                        : null;
                return GestureDetector(
                  onTap: () async {
                    final nextPath =
                        await Navigator.pushNamed(context, "/notifications");
                    if (nextPath != null) {
                      switch (nextPath) {
                        case 'chat':
                          setState(() {
                            _selectedIndex = 3;
                          });
                          break;
                        case "requests":
                          setState(() {
                            _selectedIndex = 1;
                          });
                          break;
                      }
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey, // Customize the border color
                            width: 1.0, // Customize the border width
                          ),
                        ),
                        child: Icon((state is UnreadNotificationsCountFetched &&
                                state.count > 0)
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_none_outlined),
                      ),
                      Positioned(
                        top: 5.0, // Adjust the position of the dot
                        right: 2.0, // Adjust the position of the dot
                        child: Container(
                          // child: textCount,
                          height: 30, // Adjust the size of the dot
                          width: 30, // Adjust the size of the dot

                          // decoration: BoxDecoration(
                          //   border: Border.all(
                          //     color: Colors.white, // Customize the border color
                          //     width: 1.0, // Customize the border width
                          //   ),
                          //   shape: BoxShape.circle,
                          //   color: Theme.of(context)
                          //       .colorScheme
                          //       .primary
                          //       .withOpacity(0.9), // Customize the dot color
                          // ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialog(
                title: 'هل تريد الخروج من التطبيق ؟',
                content: const Text(
                    'هل أنت حقا متأكد ومتيقن ومتثبت ومدرك لرغبتك في الخروج من هذا التطبيق ؟'),
                actions: [
                  ElevatedButton(
                    onPressed: () => {
                      SystemNavigator.pop(),
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
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.7)), // Accent color
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            height: 60,
            child: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              backgroundColor: Colors.white,
              indicatorColor: const Color(0xFFDD88CF),
              elevation: 0,
              // Change the bar's background color
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index; // Update the selected index
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  selectedIcon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  label: 'الاستمارات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.import_export_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  selectedIcon:
                      const Icon(Icons.import_export, color: Colors.white),
                  label: 'سحل الطلبات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.star_outline,
                      color: Theme.of(context).colorScheme.primary),
                  selectedIcon: const Icon(Icons.star, color: Colors.white),
                  label: 'المحفوظات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline,
                      color: Theme.of(context).colorScheme.primary),
                  selectedIcon:
                      const Icon(Icons.chat_bubble, color: Colors.white),
                  label: 'التنبيهات',
                ),
                // NavigationDestination(
                //   icon: Icon(Icons.article_outlined),
                //   selectedIcon: Icon(Icons.article),
                //   label: 'المقالات',
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
