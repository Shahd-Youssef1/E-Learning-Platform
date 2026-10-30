import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 3. تهيئة السوبابيز هنا بالـ URL والـ Anon Key بتوعك
  await Supabase.initialize(
    url: 'https://wgnxliayvyaxiwvlasnn.supabase.co',
    anonKey: 'sb_publishable_a8e6uTO5sK0CIjf6Jbm_kg_MTtEoH8R',
  );

  runApp(const EduFlowApp());
}

class EduFlowApp extends StatelessWidget {
  const EduFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //initialRoute
      debugShowCheckedModeBanner: false,
      title: 'EduFlow',
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}
