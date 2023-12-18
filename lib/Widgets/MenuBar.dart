import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/Consts.dart';
import '../Views/login.dart';

Widget buildMenuBar({required int selectedIndex}) {
  return MenuBar(selectedIndex: selectedIndex);
}

class MenuBar extends StatelessWidget {
  const MenuBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 213, 255, 251), Colors.teal.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: AppBar().preferredSize.width,
        height: 135, // Adjust the height as desired
        child: FittedBox(
          fit: BoxFit.contain, // Use a suitable fit option for the image
          child: Image.asset(
            'assets/bg.png',
          ),
        ),
      ),
    ],
  ),
),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Consts.onItemTapped(context, 0);
            },
            selected: selectedIndex == 0,
          ),
          ListTile(
            leading: const Icon(Icons.date_range_outlined),
            title: const Text('Reservation'),
            onTap: () {
              Consts.onItemTapped(context, 1);
            },
            selected: selectedIndex == 1,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Consts.onItemTapped(context, 2);
            },
            selected: selectedIndex == 2,
          ),
          ListTile(
            leading: const Icon(Icons.logout_sharp),
            title: const Text('Deconnexion'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PageLogin(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
