import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/pages/home_shell.dart';

void main() {
  testWidgets('home shell shows grouped tabs and the Live hub', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const HomeShell()),
    );

    // Bottom-nav destinations.
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Analyze'), findsOneWidget);
    expect(find.text('3D'), findsOneWidget);
    expect(find.text('Clinical'), findsOneWidget);

    // Live tab is shown first with its grouped cards.
    expect(find.text('Live Camera'), findsOneWidget);
    expect(find.text('Segment Analysis'), findsOneWidget);
  });

  testWidgets('switching to the Analyze tab shows its modes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const HomeShell()),
    );

    await tester.tap(find.text('Analyze'));
    await tester.pumpAndSettle();

    expect(find.text('Video Analysis'), findsOneWidget);
    expect(find.text('Gait Analysis'), findsOneWidget);
    expect(find.text('Image Analysis'), findsOneWidget);
  });
}
