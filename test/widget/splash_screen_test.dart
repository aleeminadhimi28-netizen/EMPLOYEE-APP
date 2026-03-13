import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_xyz/screens/intro/splash_screen.dart';

void main() {
  testWidgets('SplashScreen should display logo and title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: const SplashScreen(),
      ),
    ));
    
    // Check for "Project XYZ" title
    expect(find.text('PROJECT XYZ'), findsOneWidget);
    
    // Check for subtitle
    expect(find.text('WORKFORCE MANAGEMENT'), findsOneWidget);
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
