import 'package:flutter/material.dart';
import 'package:flutter_simple_page/Views/ReservationListScreen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../Views/Profile.dart';
import '../Views/TerrainListScreen.dart';

class Consts {
  static final navBarItems = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Home"),
      selectedColor: Colors.teal,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.calendar_today_outlined),
      title: const Text("Reservation"),
      selectedColor: Colors.pink,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.account_circle),
      title: const Text("Profile"),
      selectedColor: Colors.purple,
    ),
  ];
  static void onItemTapped(BuildContext context,int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  TerrainListScreen(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  ReservationListScreen(),
          ),
        );
        break;
      case 2:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  Profile(),
          ),
        );
        break;
    }
  }
}