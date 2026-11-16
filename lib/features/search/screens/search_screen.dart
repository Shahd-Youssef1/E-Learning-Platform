import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../data/app_data.dart';
import '../../../models/course_model.dart';
import '../../courses/screens/courses_screen.dart';
import '../../courses/widgets/course_card.dart';
import '../../courses/widgets/search_field.dart';
import '../widgets/skill_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _recent = [
    'Flutter',
    'Python',
    'UI/UX',
    'JavaScript',
    'Marketing',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String term) {
    final q = term.trim();
    if (q.isEmpty) return;
    setState(() {
      _recent.remove(q);
      _recent.insert(0, q);
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CoursesScreen(initialQuery: q)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mostSearched =
    AppData.courses.map(CourseModel.fromJson).take(3).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Back + search
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.textPrimary,
                ),
                Expanded(
                  child: AppSearchField(
                    controller: _controller,
                    hint: 'Search for a course, skill or topic...',
                    autofocus: true,
                    onSubmitted: _search,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Recent searches
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent searches',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(_recent.clear),
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final term in _recent)
                  InputChip(
                    label: Text(term),
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                    deleteIconColor: AppColors.textMuted,
                    onPressed: () => _search(term),
                    onDeleted: () => setState(() => _recent.remove(term)),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Most searched
            const Text(
              'Most searched',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final course in mostSearched) ...[
              CourseCard(course: course),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),

            // Browse by skill
            const Text(
              'Browse by skill',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            SkillGrid(onSelect: _search),
          ],
        ),
      ),
    );
  }
}