// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_xyz/services/auth_service.dart';
import 'package:project_xyz/core/theme.dart';
import 'package:project_xyz/screens/intro/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  testWidgets('Onboarding flow smoke test', (WidgetTester tester) async {
    final mockAuth = MockAuthService();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: mockAuth,
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const OnboardingScreen(),
          ),
        ),
      ),
    );

    // Verify that our onboarding screen starts.
    expect(find.text('Precision Locating'), findsOneWidget);
    expect(find.text('Face Verified'), findsNothing);

    // Tap the 'Next' button.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that we are on the next slide.
    expect(find.text('Face Verified'), findsOneWidget);
  });
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    return ByteData.view(Uint8List.fromList([
      0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 
      0x00, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x21, 0xf9, 0x04, 0x01, 0x00, 
      0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 
      0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3b
    ]).buffer);
  }
}
