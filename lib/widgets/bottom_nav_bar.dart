import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<IconData> icons = [
    Icons.home_rounded,
    Icons.menu_book_rounded,
    Icons.bar_chart_rounded,
    Icons.quiz_rounded,
    Icons.person_rounded,
  ];

  static const List<String> labels = [
    'Home',
    'Courses',
    'Progress',
    'Quizzes',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        elevation: 0,
        items: List.generate(
          icons.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(icons[index]),
            label: labels[index],
          ),
        ),
      ),
    );
  }
}
