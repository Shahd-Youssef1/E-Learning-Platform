import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class SkillGrid extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const SkillGrid({super.key, required this.onSelect});

  static const _skills = [
    ('AI', Icons.smart_toy_outlined),
    ('Cloud', Icons.cloud_outlined),
    ('Security', Icons.lock_outline_rounded),
    ('Mobile', Icons.phone_android_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _skills.length; i++) ...[
          if (i != 0) const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => onSelect(_skills[i].$1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(_skills[i].$2, color: AppColors.primary, size: 28),
                    const SizedBox(height: 6),
                    Text(
                      _skills[i].$1,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}