import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sharpsheel/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Navigation Tests', () {
    testWidgets('Should navigate through all main screens', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Test 1: Check if we're on the users list screen initially
      expect(find.text('Users List'), findsOneWidget);

      // Test 2: Open the navigation drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Test 3: Navigate to First Screen
      await tester.tap(find.text('First Screen'));
      await tester.pumpAndSettle();
      
      // Verify we're on the First Screen
      expect(find.text('First Screen'), findsWidgets);

      // Test 4: Navigate to Second Screen via drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Second Screen'));
      await tester.pumpAndSettle();
      
      // Verify we're on the Second Screen
      expect(find.text('Second Screen'), findsWidgets);

      // Test 5: Navigate to Flutter Keys Implementation
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Flutter Keys'));
      await tester.pumpAndSettle();
      
      // Verify we're on the Flutter Keys screen
      expect(find.text('Flutter Keys Implementation'), findsOneWidget);

      // Test 6: Navigate to Testing Guide
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Testing Guide'));
      await tester.pumpAndSettle();
      
      // Verify we're on the Testing Guide screen
      expect(find.text('Flutter Testing Guide'), findsOneWidget);
    });
  });

  group('Flutter Keys Screen Integration Tests', () {
    testWidgets('Should interact with different key types', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Flutter Keys screen
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Flutter Keys'));
      await tester.pumpAndSettle();

      // Test ValueKey tab
      await tester.tap(find.text('ValueKey'));
      await tester.pumpAndSettle();
      
      // Try to interact with ValueKey demo
      final valueKeyButton = find.byKey(const ValueKey('demo_button'));
      if (valueKeyButton.evaluate().isNotEmpty) {
        await tester.tap(valueKeyButton);
        await tester.pumpAndSettle();
      }

      // Test ObjectKey tab
      await tester.tap(find.text('ObjectKey'));
      await tester.pumpAndSettle();

      // Test UniqueKey tab
      await tester.tap(find.text('UniqueKey'));
      await tester.pumpAndSettle();

      // Test GlobalKey tab
      await tester.tap(find.text('GlobalKey'));
      await tester.pumpAndSettle();

      // Test PageStorageKey tab
      await tester.tap(find.text('PageStorageKey'));
      await tester.pumpAndSettle();
    });
  });

  group('Testing Guide Integration Tests', () {
    testWidgets('Should interact with testing examples', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Testing Guide
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Testing Guide'));
      await tester.pumpAndSettle();

      // Test Overview tab
      expect(find.text('Overview'), findsOneWidget);
      
      // Test Unit Testing tab
      await tester.tap(find.text('Unit Testing'));
      await tester.pumpAndSettle();
      
      // Test Widget Testing tab
      await tester.tap(find.text('Widget Testing'));
      await tester.pumpAndSettle();
      
      // Try to interact with counter demo
      final incrementButton = find.byIcon(Icons.add);
      if (incrementButton.evaluate().isNotEmpty) {
        await tester.tap(incrementButton.first);
        await tester.pumpAndSettle();
        
        // Verify counter increased
        expect(find.text('1'), findsOneWidget);
      }

      // Test Integration Testing tab
      await tester.tap(find.text('Integration Testing'));
      await tester.pumpAndSettle();
    });
  });

  group('Fifth Screen State Management Tests', () {
    testWidgets('Should manage list state with ValueNotifier', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Fifth Screen
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fifth Screen'));
      await tester.pumpAndSettle();

      // Check if list is displayed
      expect(find.byType(ListView), findsOneWidget);
      
      // Look for add button if it exists
      final addButton = find.byIcon(Icons.add);
      if (addButton.evaluate().isNotEmpty) {
        final initialItemCount = find.byType(ListTile).evaluate().length;
        
        await tester.tap(addButton);
        await tester.pumpAndSettle();
        
        // Verify new item was added
        final newItemCount = find.byType(ListTile).evaluate().length;
        expect(newItemCount, greaterThan(initialItemCount));
      }
    });
  });

  group('Form Validation Tests', () {
    testWidgets('Should validate forms across different screens', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Second Screen (which might have forms)
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Second Screen'));
      await tester.pumpAndSettle();

      // Look for text fields
      final textFields = find.byType(TextFormField);
      if (textFields.evaluate().isNotEmpty) {
        // Test empty validation
        final submitButton = find.byType(ElevatedButton);
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton.first);
          await tester.pumpAndSettle();
          
          // Should show validation errors
          expect(find.textContaining('required'), findsWidgets);
        }

        // Test valid input
        await tester.enterText(textFields.first, 'Valid input');
        await tester.pumpAndSettle();
        
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton.first);
          await tester.pumpAndSettle();
        }
      }
    });
  });

  group('Performance Tests', () {
    testWidgets('Should load screens within acceptable time', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      // Navigate to different screens and measure load time
      final screens = [
        'First Screen',
        'Second Screen',
        'Flutter Keys',
        'Testing Guide',
      ];

      for (final screen in screens) {
        final screenStopwatch = Stopwatch()..start();
        
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        await tester.tap(find.text(screen));
        await tester.pumpAndSettle();
        
        screenStopwatch.stop();
        print('$screen loaded in ${screenStopwatch.elapsedMilliseconds}ms');
        
        // Ensure screen loads within 3 seconds
        expect(screenStopwatch.elapsedMilliseconds, lessThan(3000));
      }

      stopwatch.stop();
      print('Total navigation test completed in ${stopwatch.elapsedMilliseconds}ms');
    });
  });
}
