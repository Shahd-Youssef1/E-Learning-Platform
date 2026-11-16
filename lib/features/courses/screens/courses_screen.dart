import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../data/app_data.dart';
import '../../../models/course_model.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_chips.dart';
import '../widgets/search_field.dart';

class CoursesScreen extends StatefulWidget {
  final String initialCategory;
  final String initialQuery;

  const CoursesScreen({
    super.key,
    this.initialCategory = 'All',
    this.initialQuery = '',
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  static const _filters = ['All', 'Programming', 'Design', 'Marketing', 'Data'];

  final List<CourseModel> _all =
  AppData.courses.map(CourseModel.fromJson).toList();

  late final TextEditingController _controller;
  late String _category;
  late String _query;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _query = widget.initialQuery;
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CourseModel> get _filtered {
    final q = _query.trim().toLowerCase();
    return _all.where((c) {
      final matchCategory = _category == 'All' || c.category == _category;
      final matchQuery = c.title.toLowerCase().contains(q);
      return matchCategory && matchQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final courses = _filtered;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppColors.textPrimary,
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Courses',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${courses.length} courses available',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppSearchField(
                controller: _controller,
                hint: 'Search courses...',
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 12),
            FilterChips(
              filters: _filters,
              selected: _category,
              onSelected: (f) => setState(() => _category = f),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: courses.isEmpty
                  ? const Center(
                child: Text(
                  'No courses found',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => CourseCard(course: courses[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}