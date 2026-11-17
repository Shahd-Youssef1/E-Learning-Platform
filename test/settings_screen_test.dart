import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_learning_platform/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen smoke test, theme, and language toggle', (WidgetTester tester) async {
    // Set a phone screen size for testing
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

    // Verify Arabic Initial State
    expect(find.text('الإعدادات'), findsOneWidget);
    expect(find.text('التفضيلات'), findsOneWidget);
    expect(find.text('الحساب'), findsOneWidget);
    expect(find.text('الدعم'), findsOneWidget);
    expect(find.text('العربية'), findsOneWidget);

    // Test tapping a switch for theme
    final switches = find.byType(Switch);
    expect(switches, findsNWidgets(4));

    await tester.tap(switches.first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 3)); // Wait for snackbar to dismiss
    await tester.pumpAndSettle();

    // Test language tile tap -> opens sheet
    final langTile = find.text('اللغة');
    expect(langTile, findsOneWidget);
    await tester.tap(langTile);
    await tester.pumpAndSettle();

    // Verify only Arabic and English exist
    expect(find.text('اختر لغة التطبيق'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // Select English
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Verify Screen switched to English!
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('App Notifications'), findsOneWidget);
    expect(find.text('Daily Study Reminder'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Privacy & Security'), findsOneWidget);
    expect(find.text('Subscription & Payment'), findsOneWidget);
    expect(find.text('Help Center'), findsOneWidget);
    expect(find.text('Contact Us'), findsOneWidget);
    expect(find.text('Rate App'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
