import 'package:flutter/material.dart';
import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (context) => const Placeholder(),
    AppRoutes.home: (context) => const Placeholder(),
    AppRoutes.search: (context) => const Placeholder(),
    AppRoutes.courses: (context) => const Placeholder(),
    AppRoutes.courseDetails: (context) => const Placeholder(),
    AppRoutes.lessonPlayer: (context) => const Placeholder(),
    AppRoutes.progress: (context) => const Placeholder(),
    AppRoutes.quizzes: (context) => const Placeholder(),
    AppRoutes.quizResult: (context) => const Placeholder(),
    AppRoutes.notifications: (context) => const Placeholder(),
    AppRoutes.certificates: (context) => const Placeholder(),
    AppRoutes.profile: (context) => const Placeholder(),
    AppRoutes.settings: (context) => const Placeholder(),
    AppRoutes.pro: (context) => const Placeholder(),
  };
}
