import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import 'app_card.dart';

class StatItem {
  final String value;
  final String label;
  const StatItem(this.value, this.label);
}

/// صف إحصائيات (3 كروت متساوية) مستخدم في شاشة التقدم والبروفايل.
class StatsCardsRow extends StatelessWidget {
  final List<StatItem> items;
  const StatsCardsRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    items[i].value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    items[i].label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
