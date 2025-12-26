import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//the complete widget shell for bottom navigations in the blog page.
class BottomNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const BottomNavigationShell({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index){
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          backgroundColor: AppPallete.backgroundColor,
          selectedItemColor: AppPallete.gradient3, // Active tab color
          unselectedItemColor: Colors.grey,        // Inactive tab color
          selectedIconTheme: const IconThemeData(size: 30), // Active icon grows
          unselectedIconTheme: const IconThemeData(size: 24),
          onTap: (index) => _onTap(context, index),
          items: const[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: ''
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_outlined), 
              label: ''
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), 
              label: ''
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), 
              label: ''
            ),
          ]
        ),
      ),
    );
  }
}