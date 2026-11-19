import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_routes.dart';
import '../../../models/course_model.dart';
import '../../profile/data/learning_repository.dart';
import '../../profile/widgets/app_card.dart';
import '../../profile/widgets/section_title.dart';
import '../../profile/widgets/state_views.dart';
import '../../profile/widgets/stats_cards_row.dart';

/// Screen 07 — تقدم التعلم
///
/// الأرقام (التقدم، الدروس المكتملة، الساعات، الكورسات، الإنجازات)
/// متحسبة من كورسات المستخدم. نشاط الأسبوع بس بيانات تجريبية لحد ما
/// الـ backend يوفّر سجل النشاط، وعليه علامة "بيانات تجريبية".
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // السبت → الجمعة (الترتيب من اليمين لليسار)
  static const List<String> _days = ['س', 'ح', 'ن', 'ت', 'ر', 'خ', 'ج'];

  // TODO(backend): بيانات تجريبية، استبدلها بسجل النشاط الفعلي.
  static const List<double> _demoWeeklyHours = [2.2, 3.6, 1.7, 5.2, 3.0, 5.5, 1.4];

  // عدد الدروس المكتملة اللي بيتفتح عنده إنجاز "سريع التعلم".
  static const int _fastLearnerLessons = 20;

  late Future<LearningData> _future;

  @override
  void initState() {
    super.initState();
    _future = LearningRepository.load();
  }

  void _reload() => setState(() => _future = LearningRepository.load());

  List<_Achievement> _achievements(LearningData data) {
    final activeEveryDay = _demoWeeklyHours.every((h) => h > 0);
    return [
      _Achievement('🔥', '7 أيام', locked: !activeEveryDay),
      _Achievement('🏅', 'أول كورس', locked: !data.hasCompletedCourse),
      _Achievement(
        '⚡',
        'سريع التعلم',
        locked: data.completedLessons < _fastLearnerLessons,
      ),
      const _Achievement('🔒', 'قريباً', locked: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
              FutureBuilder<LearningData>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LoadingView();
                  }
                  if (snapshot.hasError) {
                    return StateMessage(
                      emoji: '⚠️',
                      title: 'تعذر تحميل تقدمك',
                      subtitle: 'تأكد من الاتصال بالإنترنت وحاول مرة أخرى',
                      actionLabel: 'إعادة المحاولة',
                      onAction: _reload,
                    );
                  }
                  final data = snapshot.data!;
                  if (data.courses.isEmpty) {
                    return StateMessage(
                      emoji: '📚',
                      title: 'لسه ما بدأتش أي كورس',
                      subtitle: 'سجّل في كورس وهيظهر تقدمك هنا',
                      actionLabel: 'تصفح الكورسات',
                      onAction: () =>
                          Navigator.pushNamed(context, AppRoutes.courses),
                    );
                  }
                  return _content(context, data);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, LearningData data) {
    final maxHours = _demoWeeklyHours.reduce((a, b) => a > b ? a : b);
    final achievements = _achievements(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GoalRing(
          progress: data.averageProgress / 100,
          label: 'متوسط تقدم كورساتك',
        ),
        const SizedBox(height: 20),
        StatsCardsRow(
          items: [
            StatItem('${data.learningHours}', 'ساعة تعلم'),
            StatItem('${data.completedLessons}', 'درس مكتمل'),
            StatItem('${data.coursesCount}', 'كورسات'),
          ],
        ),
        const SizedBox(height: 24),
        SectionTitle(
          title: 'نشاطك هذا الأسبوع',
          trailing: '$maxHours ساعة · بيانات تجريبية',
        ),
        const SizedBox(height: 12),
        _WeeklyChart(
          days: _days,
          hours: _demoWeeklyHours,
          maxHours: maxHours,
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'الإنجازات'),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 0; i < achievements.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(child: _AchievementCard(item: achievements[i])),
            ],
          ],
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'الكورسات الحالية'),
        const SizedBox(height: 12),
        for (final course in data.courses) ...[
          _CurrentCourseCard(
            course: course,
            // بنبعت نفس الكورس (CourseModel) فبتتفتح تفاصيله هو بالذات.
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.courseDetails,
              arguments: course,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _GoalRing extends StatelessWidget {
  final double progress;
  final String label;
  const _GoalRing({required this.progress, required this.label});

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
                Text(
                  label,
                  style: const TextStyle(
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
      child: Opacity(
        opacity: item.locked ? 0.55 : 1,
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
      ),
    );
  }
}

class _CurrentCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onTap;

  const _CurrentCourseCard({required this.course, required this.onTap});

  static const Map<String, String> _levels = {
    'Beginner': 'مبتدئ',
    'Intermediate': 'متوسط',
    'Advanced': 'متقدم',
  };

  static const Map<String, String> _emojis = {
    'Programming': '💻',
    'Design': '🎨',
    'Marketing': '📣',
    'Data': '📊',
  };

  @override
  Widget build(BuildContext context) {
    final level = _levels[course.level] ?? course.level;
    final emoji = _emojis[course.category] ?? '📚';

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
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
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
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
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
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
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
