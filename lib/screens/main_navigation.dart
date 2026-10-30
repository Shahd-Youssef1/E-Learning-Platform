import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';
import 'placeholder_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    PlaceholderScreen(title: 'Home'),
    PlaceholderScreen(title: 'Courses'),
    PlaceholderScreen(title: 'Progress'),
    PlaceholderScreen(title: 'Quizzes'),
    PlaceholderScreen(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
