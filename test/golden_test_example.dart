import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharpsheel/screens/flutter_testing_guide.dart';

void main() {
  group('Golden Tests', () {
    testWidgets('FlutterTestingGuide golden test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterTestingGuide(),
        ),
      );

      // Wait for any animations to complete
      await tester.pumpAndSettle();

      // Take a screenshot and compare with golden file
      await expectLater(
        find.byType(FlutterTestingGuide),
        matchesGoldenFile('testing_guide_screen.png'),
      );
    });

    testWidgets('Testing Guide Overview Tab golden test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterTestingGuide(),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure we're on the Overview tab
      expect(find.text('Overview'), findsOneWidget);

      // Take a screenshot of the overview tab
      await expectLater(
        find.byType(FlutterTestingGuide),
        matchesGoldenFile('testing_guide_overview_tab.png'),
      );
    });

    testWidgets('Testing Guide Unit Testing Tab golden test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterTestingGuide(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Unit Testing tab
      await tester.tap(find.text('Unit Testing'));
      await tester.pumpAndSettle();

      // Take a screenshot of the unit testing tab
      await expectLater(
        find.byType(FlutterTestingGuide),
        matchesGoldenFile('testing_guide_unit_testing_tab.png'),
      );
    });

    testWidgets('Counter Widget Interactions golden test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterTestingGuide(),
        ),
      );

      await tester.pumpAndSettle();

      // Navigate to Widget Testing tab
      await tester.tap(find.text('Widget Testing'));
      await tester.pumpAndSettle();

      // Take initial screenshot
      await expectLater(
        find.byType(FlutterTestingGuide),
        matchesGoldenFile('testing_guide_widget_testing_initial.png'),
      );

      // Find and tap increment button if it exists
      final incrementButton = find.byIcon(Icons.add);
      if (incrementButton.evaluate().isNotEmpty) {
        await tester.tap(incrementButton.first);
        await tester.pumpAndSettle();

        // Take screenshot after increment
        await expectLater(
          find.byType(FlutterTestingGuide),
          matchesGoldenFile('testing_guide_widget_testing_incremented.png'),
        );
      }
    });
  });

  group('Accessibility Tests', () {
    testWidgets('FlutterTestingGuide meets accessibility guidelines', (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterTestingGuide(),
        ),
      );

      await tester.pumpAndSettle();

      // Test for minimum touch target size
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      
      // Test for sufficient contrast ratios
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      
      // Test for proper semantic labels
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

      handle.dispose();
    });
  });

  group('Responsive Design Tests', () {
    testWidgets('FlutterTestingGuide works on different screen sizes', (WidgetTester tester) async {
      // Test mobile size
      await tester.binding.setSurfaceSize(Size(375, 667)); // iPhone SE size
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterTestingGuide(),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.byType(FlutterTestingGuide), findsOneWidget);

      // Test tablet size
      await tester.binding.setSurfaceSize(Size(768, 1024)); // iPad size
      await tester.pumpAndSettle();
      
      expect(find.byType(FlutterTestingGuide), findsOneWidget);

      // Test desktop size
      await tester.binding.setSurfaceSize(Size(1920, 1080)); // Desktop size
      await tester.pumpAndSettle();
      
      expect(find.byType(FlutterTestingGuide), findsOneWidget);

      // Reset to default size
      await tester.binding.setSurfaceSize(null);
    });
  });
}
