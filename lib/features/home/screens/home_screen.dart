import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_routes.dart';
import '../../../data/app_data.dart';
import '../../../models/course_model.dart';
import '../../courses/screens/courses_screen.dart';
import '../../courses/widgets/course_card.dart';
import '../../courses/widgets/search_field.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/categories_grid.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/session_card.dart';
import '../widgets/stats_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final courses = AppData.courses.map(CourseModel.fromJson).toList();
    final continueCourse = courses.first; // Flutter - 60%
    final recommended = courses.skip(1).take(3).toList();
    final firstName = (AppData.user['name'] as String).split(' ').first;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $firstName 👋',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'What do you want to learn today?',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.notifications),
                    icon: const Icon(Icons.notifications_none_rounded),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search
            AppSearchField(
              hint: 'Search for a course, skill or topic...',
              readOnly: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
            ),
            const SizedBox(height: 16),

            // Continue learning
            ContinueLearningCard(
              course: continueCourse,
              onContinue: () => openCourseDetails(context, continueCourse),
            ),
            const SizedBox(height: 16),

            const StatsRow(),
            const SizedBox(height: 16),

            SessionCard(
              onRegister: () => _snack(context, 'Registered successfully ✅'),
            ),
            const SizedBox(height: 20),

            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CoursesScreen()),
                  ),
                  child: const Text(
                    'View all',
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CategoriesGrid(
              onSelect: (category) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CoursesScreen(initialCategory: category),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recommended
            const Text(
              'Recommended paths',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final course in recommended) ...[
              CourseCard(course: course),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}