import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/progress/screens/progress_screen.dart';
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
    ProgressScreen(),
    PlaceholderScreen(title: 'Quizzes'),
    ProfileScreen(),
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
