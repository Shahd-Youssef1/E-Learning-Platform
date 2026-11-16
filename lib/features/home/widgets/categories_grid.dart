import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../courses/widgets/course_card.dart';

class CategoriesGrid extends StatelessWidget {
  final ValueChanged<String> onSelect;

  const CategoriesGrid({super.key, required this.onSelect});

  static const _categories = ['Programming', 'Design', 'Marketing', 'Data'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _categories.length; i++) ...[
          if (i != 0) const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => onSelect(_categories[i]),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(
                      categoryIcon(_categories[i]),
                      color: AppColors.primary,
                      size: 26,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _categories[i],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
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