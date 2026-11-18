import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/section_title.dart';

/// Screen 14 — اشتراك EduFlow Pro
class ProScreen extends StatefulWidget {
  const ProScreen({super.key});

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _Plan {
  final String title;
  final int price;
  final String note;
  const _Plan(this.title, this.price, this.note);
}

class _ProScreenState extends State<ProScreen> {
  static const List<_Plan> _plans = [
    _Plan('شهري', 12, 'لكل شهر'),
    _Plan('سنوي', 79, 'وفّر 45%'),
    _Plan('مؤسسات', 199, 'لكل فريق'),
  ];

  static const List<String> _features = [
    'وصول غير محدود لأكثر من 5,000 كورس',
    'شهادات معتمدة قابلة للتوثيق',
    'تحميل الدروس والتعلم بدون إنترنت',
    'جلسات مباشرة ومراجعة الكود مع المحاضرين',
    'مسارات مهنية مخصصة بالذكاء الاصطناعي',
  ];

  int _selected = 1; // السنوي هو الافتراضي زي الـ Figma

  void _subscribe() {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: const Text(
            'تم التفعيل ✅',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _TopBar(onBack: () => Navigator.maybePop(context)),
              const SizedBox(height: 16),
              const _HeroCard(),
              const SizedBox(height: 16),
              Row(
                children: [
                  for (int i = 0; i < _plans.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(
                      child: _PlanCard(
                        plan: _plans[i],
                        selected: i == _selected,
                        onTap: () => setState(() => _selected = i),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              const SectionTitle(title: 'ماذا تحصل عليه؟'),
              const SizedBox(height: 8),
              for (int i = 0; i < _features.length; i++) ...[
                _FeatureRow(text: _features[i]),
                if (i < _features.length - 1)
                  const Divider(height: 1, color: AppColors.border),
              ],
              const SizedBox(height: 20),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: const [
                    Text('💳', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Visa •••• 4242',
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'تغيير',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _subscribe,
                  child: Text(
                    'اشترك الآن · \$${_plans[_selected].price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'إلغاء في أي وقت · ضمان استرجاع 7 أيام',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  const _TopBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppCard(
          onTap: onBack,
          padding: EdgeInsets.zero,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.arrow_forward_rounded,
              textDirection: TextDirection.ltr,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Expanded(
          child: Text(
            'EduFlow Pro',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primary, AppColors.live],
        ),
      ),
      child: const Column(
        children: [
          Text('👑', style: TextStyle(fontSize: 48)),
          SizedBox(height: 8),
          Text(
            'انطلق بلا حدود',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'وصول كامل لكل الكورسات والشهادات',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: selected ? AppColors.surfacePurple : AppColors.surface,
      borderColor: selected ? AppColors.primary : AppColors.border,
      borderWidth: selected ? 2 : 1,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            plan.title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${plan.price}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            plan.note,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
