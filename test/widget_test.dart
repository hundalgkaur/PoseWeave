import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/pages/home_shell.dart';

void main() {
  testWidgets('home dashboard shows greeting, streak and feature grid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const HomeShell()),
    );

    // Dashboard chrome.
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('ACTIVE STREAK · DEMO'), findsOneWidget);
    expect(find.text('QUICK ACTIONS'), findsOneWidget);

    // Feature grid keeps every mode reachable.
    expect(find.text('Live Camera'), findsOneWidget);
    expect(find.text('Rep Counter'), findsOneWidget);
    expect(find.text('Diagnostic'), findsOneWidget);
  });

  testWidgets('home shows the 5-item bottom nav', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const HomeShell()),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
    expect(find.text('Rank'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
