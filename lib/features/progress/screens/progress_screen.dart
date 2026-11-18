import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_routes.dart';
import '../../../models/course_model.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/section_title.dart';
import '../../../widgets/stats_cards_row.dart';

/// Screen 07 — تقدم التعلم
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  // TODO: استبدلها ببيانات الـ API لما تتوفر (حاليًا قيم الـ Figma).
  static const double _weeklyGoal = 0.6;

  static const List<StatItem> _stats = [
    StatItem('18', 'ساعة تعلم'),
    StatItem('89', 'درس مكتمل'),
    StatItem('3', 'كورسات'),
  ];

  // السبت → الجمعة (الترتيب من اليمين لليسار)
  static const List<String> _days = ['س', 'ح', 'ن', 'ت', 'ر', 'خ', 'ج'];
  static const List<double> _weeklyHours = [2.2, 3.6, 1.7, 5.2, 3.0, 5.5, 1.4];

  static const List<_Achievement> _achievements = [
    _Achievement('🔥', '7 أيام'),
    _Achievement('🏅', 'أول كورس'),
    _Achievement('⚡', 'سريع التعلم'),
    _Achievement('🔒', 'قريباً', locked: true),
  ];

  // الكورسات الحالية زي الـ Figma.
  // TODO: استبدلها ببيانات الـ API/الـ enrollments لما تتوفر.
  static const List<_CurrentCourse> _courses = [
    _CurrentCourse(
      '💙',
      CourseModel(
        id: 1,
        title: 'Flutter من الصفر للاحتراف',
        instructor: 'أحمد السيد',
        category: 'Programming',
        rating: 4.9,
        level: 'Beginner',
        hours: 20,
        lessons: 48,
        progress: 60,
        description: '',
      ),
    ),
    _CurrentCourse(
      '🎨',
      CourseModel(
        id: 2,
        title: 'تصميم واجهات UI/UX',
        instructor: 'سارة محمود',
        category: 'Design',
        rating: 4.8,
        level: 'Intermediate',
        hours: 15,
        lessons: 36,
        progress: 35,
        description: '',
      ),
    ),
    _CurrentCourse(
      '⚡',
      CourseModel(
        id: 3,
        title: 'JavaScript المتقدم',
        instructor: 'محمد علي',
        category: 'Programming',
        rating: 4.7,
        level: 'Advanced',
        hours: 18,
        lessons: 44,
        progress: 100,
        description: '',
      ),
    ),
    _CurrentCourse(
      '📣',
      CourseModel(
        id: 4,
        title: 'التسويق الرقمي',
        instructor: 'نورهان خالد',
        category: 'Marketing',
        rating: 4.6,
        level: 'Beginner',
        hours: 12,
        lessons: 28,
        progress: 10,
        description: '',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final maxHours = _weeklyHours.reduce((a, b) => a > b ? a : b);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              const Text(
                'تقدم التعلم',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'أحسنت! استمر في رحلتك 🚀',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              _GoalRing(progress: _weeklyGoal),
              const SizedBox(height: 20),
              const StatsCardsRow(items: _stats),
              const SizedBox(height: 24),
              SectionTitle(
                title: 'نشاطك هذا الأسبوع',
                trailing: '$maxHours ساعة',
              ),
              const SizedBox(height: 12),
              _WeeklyChart(
                days: _days,
                hours: _weeklyHours,
                maxHours: maxHours,
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'الإنجازات'),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (int i = 0; i < _achievements.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(child: _AchievementCard(item: _achievements[i])),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'الكورسات الحالية'),
              const SizedBox(height: 12),
              for (final item in _courses) ...[
                _CurrentCourseCard(
                  item: item,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.courseDetails,
                    arguments: item.course,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalRing extends StatelessWidget {
  final double progress;
  const _GoalRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 190,
        height: 190,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => SizedBox.expand(
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 14,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.surfacePurple,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'من هدفك الأسبوعي',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<String> days;
  final List<double> hours;
  final double maxHours;

  const _WeeklyChart({
    required this.days,
    required this.hours,
    required this.maxHours,
  });

  static const double _barAreaHeight = 100;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
      child: SizedBox(
        height: _barAreaHeight + 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < days.length; i++)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0,
                      end: _barAreaHeight * hours[i] / maxHours,
                    ),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, height, _) => Container(
                      width: 30,
                      height: height,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8),
                          bottom: Radius.circular(4),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.primary, AppColors.primaryMedium],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[i],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Achievement {
  final String icon;
  final String title;
  final bool locked;
  const _Achievement(this.icon, this.title, {this.locked = false});
}

class _AchievementCard extends StatelessWidget {
  final _Achievement item;
  const _AchievementCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: item.locked ? AppColors.surfaceSecondary : AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item.icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 6),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: item.locked
                  ? AppColors.textMuted
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentCourse {
  final String emoji;
  final CourseModel course;
  const _CurrentCourse(this.emoji, this.course);
}

class _CurrentCourseCard extends StatelessWidget {
  final _CurrentCourse item;
  final VoidCallback onTap;

  const _CurrentCourseCard({required this.item, required this.onTap});

  CourseModel get course => item.course;

  static const Map<String, String> _levels = {
    'Beginner': 'مبتدئ',
    'Intermediate': 'متوسط',
    'Advanced': 'متقدم',
  };

  @override
  Widget build(BuildContext context) {
    const barColor = AppColors.primary;
    final level = _levels[course.level] ?? course.level;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfacePurple,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfacePurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${course.progress}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: barColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${course.instructor} · ${course.lessons} درس · ⭐ ${course.rating} · $level',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: course.progress / 100,
                    minHeight: 5,
                    backgroundColor: AppColors.surfacePurple,
                    valueColor: AlwaysStoppedAnimation(barColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
