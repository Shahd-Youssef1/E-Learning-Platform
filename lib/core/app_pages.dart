
import 'package:flutter/material.dart';

import '../features/auth/screens/login_in.dart';
import '../features/courses/screens/course_details_screen.dart';
import '../features/courses/screens/courses_screen.dart';
import '../features/courses/screens/lesson_player_screen.dart';
import '../features/navigation/screens/main_navigation.dart';
import '../features/search/screens/search_screen.dart';
import '../features/settings/screens/settings_screen.dart';

import '../features/profile/screens/profile_screen.dart';
import '../features/pro/screens/pro_screen.dart';
import '../features/progress/screens/progress_screen.dart';
import '../features/certificates/screens/certificates_screen.dart';

import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (context) => const LoginInScreen(),
    AppRoutes.home: (context) => const MainNavigation(),
    AppRoutes.search: (context) => const SearchScreen(),
    AppRoutes.courses: (context) => const CoursesScreen(),
    AppRoutes.courseDetails: (context) => const CourseDetailsScreen(),
    AppRoutes.lessonPlayer: (context) => const LessonPlayerScreen(),

    AppRoutes.progress: (context) => const ProgressScreen(),
    AppRoutes.quizzes: (context) => const Placeholder(),
    AppRoutes.quizResult: (context) => const Placeholder(),
    AppRoutes.notifications: (context) => const Placeholder(),
    AppRoutes.certificates: (context) => const CertificatesScreen(),
    AppRoutes.profile: (context) => const ProfileScreen(),
    AppRoutes.settings: (context) => const SettingsScreen(),
    AppRoutes.pro: (context) => const ProScreen(),
  };
}
