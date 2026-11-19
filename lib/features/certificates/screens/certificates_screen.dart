import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../../../models/certificate_model.dart';
import '../../profile/data/learning_repository.dart';
import '../../profile/widgets/app_card.dart';
import '../../profile/widgets/state_views.dart';

/// شاشة شهاداتي — بتعرض كل شهادات المستخدم.
class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  late Future<LearningData> _future;

  @override
  void initState() {
    super.initState();
    _future = LearningRepository.load();
  }

  void _reload() => setState(() => _future = LearningRepository.load());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Row(
                children: [
                  AppCard(
                    onTap: () => Navigator.maybePop(context),
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
                      'شهاداتي',
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
              ),
              const SizedBox(height: 16),
              FutureBuilder<LearningData>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LoadingView();
                  }
                  if (snapshot.hasError) {
                    return StateMessage(
                      emoji: '⚠️',
                      title: 'تعذر تحميل الشهادات',
                      actionLabel: 'إعادة المحاولة',
                      onAction: _reload,
                    );
                  }
                  final certificates = snapshot.data!.certificates;
                  if (certificates.isEmpty) {
                    return const StateMessage(
                      emoji: '🎓',
                      title: 'لسه ما حصلتش على شهادات',
                      subtitle: 'أكمل أي كورس وهتلاقي شهادتك هنا',
                    );
                  }
                  return Column(
                    children: [
                      for (final c in certificates) ...[
                        _CertificateTile(certificate: c),
                        const SizedBox(height: 10),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificateTile extends StatelessWidget {
  final CertificateModel certificate;
  const _CertificateTile({required this.certificate});

  @override
  Widget build(BuildContext context) {
    return AppCard(
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
        ],
      ),
    );
  }
}
