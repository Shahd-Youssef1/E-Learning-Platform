import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_routes.dart';
import '../../../models/user_model.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/section_title.dart';
import '../../../widgets/stats_cards_row.dart';

/// Screen 12 — الملف الشخصي
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // TODO: استبدلها ببيانات الـ API لما تتوفر (حاليًا قيم الـ Figma).
  static const List<StatItem> _stats = [
    StatItem('120', 'ساعة تعلم'),
    StatItem('45', 'شهادة'),
    StatItem('12', 'كورس'),
  ];

  static const List<(String, int)> _skills = [
    ('Flutter', 85),
    ('UI/UX', 70),
    ('JavaScript', 60),
    ('Python', 40),
  ];

  // TODO: استبدلهم ببيانات اليوزر والشهادات من الـ API (حاليًا قيم الـ Figma).
  static const UserModel _user = UserModel(
    id: 'U001',
    name: 'أحمد محمد',
    email: 'ahmed@example.com',
    isPro: true,
  );
  static const String _certTitle = 'JavaScript المتقدم';
  static const String _certSubtitle = 'صدرت في أكتوبر 2026 · EF-2026-0481';

  void _go(BuildContext context, String route) =>
      Navigator.pushNamed(context, route);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            children: [
              _Header(user: _user, onProTap: () => _go(context, AppRoutes.pro)),
              const SizedBox(height: 20),
              const StatsCardsRow(items: _stats),
              const SizedBox(height: 24),
              const SectionTitle(title: 'مهاراتي'),
              const SizedBox(height: 12),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (int i = 0; i < _skills.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      _SkillBar(name: _skills[i].$1, level: _skills[i].$2),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SectionTitle(
                title: 'شهاداتي',
                trailing: 'عرض الكل',
                onTrailingTap: () => _go(context, AppRoutes.certificates),
              ),
              const SizedBox(height: 12),
              _CertificateCard(
                title: _certTitle,
                subtitle: _certSubtitle,
                onTap: () => _go(context, AppRoutes.certificates),
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MenuItem(
                      emoji: '📚',
                      label: 'كورساتي',
                      onTap: () => _go(context, AppRoutes.courses),
                    ),
                    const _MenuDivider(),
                    _MenuItem(
                      emoji: '🎓',
                      label: 'شهاداتي',
                      onTap: () => _go(context, AppRoutes.certificates),
                    ),
                    const _MenuDivider(),
                    _MenuItem(
                      emoji: '📝',
                      label: 'الاختبارات',
                      onTap: () => _go(context, AppRoutes.quizzes),
                    ),
                    const _MenuDivider(),
                    _MenuItem(
                      emoji: '⚙️',
                      label: 'الإعدادات',
                      onTap: () => _go(context, AppRoutes.settings),
                    ),
                    const _MenuDivider(),
                    _MenuItem(
                      emoji: '🚪',
                      label: 'تسجيل الخروج',
                      onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UserModel user;
  final VoidCallback onProTap;

  const _Header({required this.user, required this.onProTap});

  @override
  Widget build(BuildContext context) {
    final name = user.name.trim();
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();

    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.live],
              ),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          user.email,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onProTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.surfacePurple,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: Text(
              user.isPro ? '👑 عضو EduFlow Pro' : '👑 الترقية إلى EduFlow Pro',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillBar extends StatelessWidget {
  final String name;
  final int level;

  const _SkillBar({required this.name, required this.level});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '$level%',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: level / 100),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: AppColors.surfacePurple,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CertificateCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            child: const Center(
              child: Text('🎓', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfacePurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'تحميل',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_left_rounded,
              textDirection: TextDirection.ltr,
              size: 22,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        thickness: 1,
        indent: 16,
        endIndent: 16,
        color: AppColors.border,
      );
}
