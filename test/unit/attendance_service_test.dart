import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_xyz/services/attendance_service.dart';

void main() {
  group('AttendanceService Geofencing Tests', () {
    final service = AttendanceService();

    // The office location defined in AttendanceService is:
    // static const double officeLat = 40.7128;
    // static const double officeLng = -74.0060;
    // static const double allowedRadius = 100.0;

    test('should return true if current position is within 100m of office', () {
      // Very close to the office coordinates
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

      expect(service.isWithinRadius(insidePos), isTrue);
    });

    test('should return false if current position is outside 100m of office', () {
      // Further away from the office coordinates
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

      expect(service.isWithinRadius(outsidePos), isFalse);
    });
  });
}
