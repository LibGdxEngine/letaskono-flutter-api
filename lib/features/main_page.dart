import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Home')),
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الاستمارات',
          ),
          NavigationDestination(
            icon: Icon(Icons.call_received_outlined),
            selectedIcon: Icon(Icons.call_received),
            label: 'سحل الطلبات',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star),
            label: 'المحفوظات',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'التنبيهات',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.article_outlined),
          //   selectedIcon: Icon(Icons.article),
          //   label: 'المقالات',
          // ),
        ],
      ),
    );
  }
}
