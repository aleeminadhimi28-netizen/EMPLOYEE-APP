import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_xyz/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Onboarding Flow', () {
    testWidgets('should navigate from Onboarding to Login', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Check for first slide
      expect(find.text('Geofenced Security'), findsOneWidget);

      // Tap next 3 times to get through onboarding
      final nextButton = find.byType(ElevatedButton);
      
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('Biometric Trust'), findsOneWidget);

      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('Task Intelligence'), findsOneWidget);

      // This tap should take us to Login
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Verify we are on the Login Screen
      expect(find.text('Project XYZ'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });
  });
}
