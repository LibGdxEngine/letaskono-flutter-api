import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letaskono_flutter/features/chat/presentation/pages/chat_list_main.dart';
import 'package:letaskono_flutter/features/notifications/presentation/pages/notifications_page.dart';
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
  int _selectedIndex = 0; // State to manage selected index

  // List of screens for navigation
  final List<Widget> _screens = [
    const UsersPage(),
    const RequestsList(),
    const FavouritesList(),
    const ChatListMain(),
    // const NotificationsPage(),
    // Center(child: Text('المقالات')),
  ];

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(); // Initialize your BLoC
    _userBloc.add(SetOnlineEvent());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _userBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive || // When app goes to background
        state == AppLifecycleState.paused) {
      _userBloc.add(SetOfflineEvent());
    }else if(state == AppLifecycleState.resumed){
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
          GestureDetector(
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
                  child: const Icon(Icons.notifications_none_outlined),
                ),
                Positioned(
                  top: 12.0, // Adjust the position of the dot
                  right: 10.0, // Adjust the position of the dot
                  child: Container(
                    height: 10, // Adjust the size of the dot
                    width: 10, // Adjust the size of the dot
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Customize the border color
                        width: 2.0, // Customize the border width
                      ),
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5), // Customize the dot color
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Name')),
            ListTile(
              title: const Text('Hello'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            const ListTile(
              title: Text('Hello'),
            ),
            const ListTile(
              title: Text('Hello'),
            ),
            const ListTile(
              title: Text('Hello'),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
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
                  selectedIcon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  label: 'الاستمارات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.import_export_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  selectedIcon: Icon(Icons.import_export, color: Colors.white),
                  label: 'سحل الطلبات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.star_outline,
                      color: Theme.of(context).colorScheme.primary),
                  selectedIcon: Icon(Icons.star, color: Colors.white),
                  label: 'المحفوظات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline,
                      color: Theme.of(context).colorScheme.primary),
                  selectedIcon: Icon(Icons.chat_bubble, color: Colors.white),
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
