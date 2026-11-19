import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

/// عنوان قسم + نص جانبي اختياري (لو ليه onTap بيتحول لرابط).
class SectionTitle extends StatelessWidget {
  final String title;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final tappable = onTrailingTap != null;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (trailing != null)
          InkWell(
            onTap: onTrailingTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                trailing!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: tappable ? FontWeight.w700 : FontWeight.w500,
                  color: tappable ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
