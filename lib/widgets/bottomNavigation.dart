import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:life_story/widgets/logOut.dart';

bottomNav(BuildContext context, Color color,bool check) {
  return BottomNavigationBar(
    elevation: 0,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    unselectedItemColor: Colors.grey,
    selectedItemColor: primary,
    unselectedIconTheme: IconThemeData(
      color: Colors.grey,
    ),
    backgroundColor: color,
    type: BottomNavigationBarType.fixed,
    currentIndex: 0,
    onTap: (index) async {
      print(index);
      if (index == 0) {
        if(check)
        Navigator.pop(context);
      }
      if (index == 1) {
        logOut(context);
      }
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
          size: 40,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person_outline,
          size: 30,
        ),
        label: 'Log out',
      ),
    ],
  );
}
