import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/pages/home_page.dart';

void main() {
  testWidgets('home page shows the three mode cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.dark, home: const HomePage()),
    );

    expect(find.text('Select Mode'), findsOneWidget);
    expect(find.text('Live Camera'), findsOneWidget);
    expect(find.text('Video Analysis'), findsOneWidget);
    expect(find.text('3D Skeleton'), findsOneWidget);
    expect(find.text('BETA'), findsOneWidget);
  });
}
