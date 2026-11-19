import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_routes.dart';
import '../../../models/certificate_model.dart';
import '../../../models/user_model.dart';
import '../../auth/services/auth_service.dart';
import '../data/learning_repository.dart';
import '../widgets/app_card.dart';
import '../widgets/section_title.dart';
import '../widgets/stats_cards_row.dart';

/// Screen 12 — الملف الشخصي
///
/// الاسم والإيميل والصورة من حساب المستخدم المسجّل، والإحصائيات والشهادات
/// متحسبة من بياناته. المهارات بس تجريبية (مفيش مصدر ليها لسه).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO(backend): بيانات تجريبية، استبدلها بمهارات المستخدم الفعلية.
  static const List<(String, int)> _demoSkills = [
    ('Flutter', 85),
    ('UI/UX', 70),
    ('JavaScript', 60),
    ('Python', 40),
  ];

  late Future<LearningData> _future;

  @override
  void initState() {
    super.initState();
    _future = LearningRepository.load();
  }

  /// بيانات المستخدم المسجّل دخوله حاليًا (من Supabase Auth).
  UserModel _currentUser() {
    final user = AuthService.currentUser;
    final meta = user?.userMetadata ?? const <String, dynamic>{};
    final email = user?.email ?? '';

    final fullName = (meta['full_name'] ?? meta['name'] ?? '').toString().trim();
    final name = fullName.isNotEmpty
        ? fullName
        : (email.contains('@') ? email.split('@').first : 'مستخدم');

    final image = (meta['avatar_url'] ?? meta['picture'])?.toString();

    return UserModel(
      id: user?.id ?? '',
      name: name,
      email: email,
      // TODO(backend): اقرأي حالة الاشتراك من جدول subscriptions.
      isPro: false,
      image: image,
    );
  }

  void _go(String route) => Navigator.pushNamed(context, route);

  Future<void> _logout() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AuthService.signOut(); // بيمسح الـ session
      navigator.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('تعذر تسجيل الخروج، حاول مرة أخرى')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            children: [
              _Header(user: user, onProTap: () => _go(AppRoutes.pro)),
              const SizedBox(height: 20),
              FutureBuilder<LearningData>(
                future: _future,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  String v(int? value) => value == null ? '—' : '$value';
                  return StatsCardsRow(
                    items: [
                      StatItem(v(data?.learningHours), 'ساعة تعلم'),
                      StatItem(v(data?.certificates.length), 'شهادة'),
                      StatItem(v(data?.coursesCount), 'كورس'),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'مهاراتي', trailing: 'بيانات تجريبية'),
              const SizedBox(height: 12),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    for (int i = 0; i < _demoSkills.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      _SkillBar(
                        name: _demoSkills[i].$1,
                        level: _demoSkills[i].$2,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SectionTitle(
                title: 'شهاداتي',
                trailing: 'عرض الكل',
                onTrailingTap: () => _go(AppRoutes.certificates),
              ),
              const SizedBox(height: 12),
              FutureBuilder<LearningData>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(height: 84);
                  }
                  final latest = snapshot.data?.latestCertificate;
                  if (latest == null) {
                    return const _NoCertificates();
                  }
                  return _CertificateCard(
                    certificate: latest,
                    onTap: () => _go(AppRoutes.certificates),
                  );
                },
              ),
              const SizedBox(height: 16),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MenuItem(
                      emoji: '📚',
                      label: 'كورساتي',
                      onTap: () => _go(AppRoutes.courses),
                    ),
                    const _MenuDivider(),
                    _MenuItem(
                      emoji: '🎓',
                      label: 'شهاداتي',
                      onTap: () => _go(AppRoutes.certificates),
                    ),
                    const _MenuDivider(),
                    _MenuItem(
                      emoji: '📝',
                      label: 'الاختبارات',
                      onTap: () => _go(AppRoutes.quizzes),
                    ),
                    const _MenuDivider(),
                    _MenuItem(
                      emoji: '⚙️',
                      label: 'الإعدادات',
                      onTap: () => _go(AppRoutes.settings),
                    ),
                    const _MenuDivider(),
                    _MenuItem(
                      emoji: '🚪',
                      label: 'تسجيل الخروج',
                      onTap: _logout,
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
    final imageUrl = user.image;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

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
          child: ClipOval(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
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
                // لو فيه صورة بتظهر فوق الحرف، ولو فشل تحميلها الحرف يفضل ظاهر.
                if (hasImage)
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        const SizedBox.shrink(),
                  ),
              ],
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
        if (user.email.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
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
  final CertificateModel certificate;
  final VoidCallback onTap;

  const _CertificateCard({required this.certificate, required this.onTap});

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
                  certificate.course,
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
                  certificateIssuedLabel(certificate),
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
              'عرض',
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

class _NoCertificates extends StatelessWidget {
  const _NoCertificates();

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text('🎓', style: TextStyle(fontSize: 26)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'لسه ما حصلتش على شهادات، أكمل كورس وهتظهر هنا',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
