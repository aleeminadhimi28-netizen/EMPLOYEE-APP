import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:project_xyz/screens/auth/login_screen.dart';
import 'package:project_xyz/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_xyz/core/theme.dart';

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
        child: MaterialApp(
          theme: AppTheme.darkTheme,
          home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const LoginScreen(),
          ),
        ),
      ),
    );

    // Verify Title and Subtitle
    expect(find.text('Project XYZ'), findsOneWidget);
    expect(find.text('Next-Gen Workforce OS'), findsOneWidget);

    // Verify Input Fields
    expect(find.byIcon(LucideIcons.mail), findsOneWidget);
    expect(find.byIcon(LucideIcons.lock), findsOneWidget);

    // Verify Button
    expect(find.widgetWithText(ElevatedButton, 'Access Portal'), findsOneWidget);
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
