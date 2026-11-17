import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:e_learning_platform/main.dart';

void main() {
  testWidgets('EduFlowApp smoke test opens MainNavigation with Home and navigates to Profile/Settings', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const EduFlowApp());
    await tester.pumpAndSettle();

    // Verify that the initial screen shows HomeScreen and bottom navigation.
    expect(find.text('What do you want to learn today?'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Courses'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Navigate to Profile tab (SettingsScreen)
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Verify that Settings screen is displayed.
    expect(find.text('الإعدادات'), findsOneWidget);
  });
}
