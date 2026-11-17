import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class SettingsBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool isDark;
  final bool isArabic;

  const SettingsBottomBar({
    super.key,
    this.currentIndex = 4,
    this.onTap,
    this.isDark = true,
    this.isArabic = true,
  });

  @override
  Widget build(BuildContext context) {
    final navBg = isDark ? const Color(0xFF0F0A20) : AppColors.surface;
    final navBorder = isDark ? const Color(0xFF1F1738) : AppColors.border;
    final activeBg = isDark ? const Color(0xFF3B2068) : AppColors.primary;
    final activeBorder = isDark ? const Color(0xFF7C3AED) : AppColors.primaryDark;
    final inactiveColor = isDark ? const Color(0xFF6B648B) : AppColors.textMuted;

    final items = [
      (isArabic ? 'الرئيسية' : 'Home', Icons.home_rounded, Icons.home_outlined),
      (isArabic ? 'الكورسات' : 'Courses', Icons.menu_book_rounded, Icons.menu_book_outlined),
      (isArabic ? 'تقدمي' : 'Progress', Icons.access_time_filled_rounded, Icons.access_time_rounded),
      (isArabic ? 'الاختبارات' : 'Quizzes', Icons.assignment_rounded, Icons.assignment_outlined),
      (isArabic ? 'حسابي' : 'Profile', Icons.person_rounded, Icons.person_outline_rounded),
    ];

    return Container(
      decoration: BoxDecoration(
        color: navBg,
        border: Border(top: BorderSide(color: navBorder, width: 1)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isSel = i == currentIndex;
              final (label, icon, outlineIcon) = items[i];

              return GestureDetector(
                onTap: () => onTap?.call(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSel ? 14 : 10,
                    vertical: 6,
                  ),
                  decoration: isSel
                      ? BoxDecoration(
                          color: activeBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: activeBorder.withValues(alpha: 0.5),
                          ),
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSel ? icon : outlineIcon,
                        color: isSel ? Colors.white : inactiveColor,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: TextStyle(
                          color: isSel ? Colors.white : inactiveColor,
                          fontSize: 11,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
