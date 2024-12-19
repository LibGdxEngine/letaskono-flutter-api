import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letaskono_flutter/features/notifications/presentation/pages/notifications_page.dart';
import 'package:letaskono_flutter/features/requests/presentation/pages/requests_page.dart';
import 'package:letaskono_flutter/features/users/presentation/pages/favourites_page.dart';
import 'package:letaskono_flutter/features/users/presentation/pages/home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // State to manage selected index

  // List of screens for navigation
  final List<Widget> _screens = [
    UsersPage(),
    RequestsList(),
    FavouritesList(),
    NotificationsPage(),
    // Center(child: Text('المقالات')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('لتسكنوا', style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.bold
        ),),
        actions: [

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
                  icon: Icon(Icons.notifications_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  selectedIcon: Icon(Icons.notifications, color: Colors.white),
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
