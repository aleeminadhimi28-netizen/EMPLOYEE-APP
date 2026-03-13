import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_xyz/services/attendance_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('AttendanceService Geofencing Tests', () {
    final mockClient = MockSupabaseClient();
    final service = AttendanceService(client: mockClient);

    // The office location defined in AttendanceService is:
    // static const double officeLat = 40.7128;
    // static const double officeLng = -74.0060;
    // static const double allowedRadius = 100.0;

    final mockSite = {
      'latitude': 40.7128,
      'longitude': -74.0060,
      'radius_meters': 100.0,
      'name': 'Test Office'
    };

    test('should return true if current position is within 100m of office', () {
      final insidePos = Position(
        latitude: 40.71285,
        longitude: -74.00605,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      expect(service.isWithinSite(insidePos, mockSite), isTrue);
    });

    test('should return false if current position is outside 100m of office', () {
      final outsidePos = Position(
        latitude: 40.7500, // Mid-town Manhattan
        longitude: -73.9850,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );

      expect(service.isWithinSite(outsidePos, mockSite), isFalse);
    });
  });
}
