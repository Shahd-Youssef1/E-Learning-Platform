import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 3. تهيئة السوبابيز هنا بالـ URL والـ Anon Key بتوعك
  await Supabase.initialize(
    url: 'https://wgnxliayvyaxiwvlasnn.supabase.co',
    publishableKey: 'sb_publishable_a8e6uTO5sK0CIjf6Jbm_kg_MTtEoH8R',
  );

  runApp(const EduFlowApp());
}

class EduFlowApp extends StatefulWidget {
  const EduFlowApp({super.key});

  @override
  State<EduFlowApp> createState() => _EduFlowAppState();
}

class _EduFlowAppState extends State<EduFlowApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduFlow',
      theme: AppTheme.lightTheme,
      home: SettingsScreen(
        isDarkMode: _isDarkMode,
        onThemeChanged: (val) {
          setState(() {
            _isDarkMode = val;
          });
        },
      ),
    );
  }
}
