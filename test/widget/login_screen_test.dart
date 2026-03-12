import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:project_xyz/screens/auth/login_screen.dart';
import 'package:project_xyz/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  testWidgets('LoginScreen should display email and password fields', (WidgetTester tester) async {
    final mockAuth = MockAuthService();
    when(() => mockAuth.isLoading).thenReturn(false);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>.value(value: mockAuth),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify Title and Subtitle
    expect(find.text('Project XYZ'), findsOneWidget);
    expect(find.text('Unified Workforce Management'), findsOneWidget);

    // Verify Input Fields
    expect(find.byIcon(LucideIcons.mail), findsOneWidget);
    expect(find.byIcon(LucideIcons.lock), findsOneWidget);

    // Verify Button
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
  });
}
