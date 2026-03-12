import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  final _supabase = Supabase.instance.client;

  // Office Location (Site)
  // These would typically come from the database per user/site
  static const double officeLat = 40.7128; // Example
  static const double officeLng = -74.0060; // Example
  static const double allowedRadius = 100.0; // Meters

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  bool isWithinRadius(Position currentPosition) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      officeLat,
      officeLng,
    );
    return distanceInMeters <= allowedRadius;
  }

  Future<void> clockIn(String userId, String faceVerificationId) async {
    await _supabase.from('attendance').insert({
      'user_id': userId,
      'check_in': DateTime.now().toIso8601String(),
      'status': 'present',
      'verified_via_face': true,
      'verified_via_gps': true,
    });
  }

  Future<void> startBreak(String attendanceId) async {
    await _supabase.from('attendance_breaks').insert({
      'attendance_id': attendanceId,
      'start_time': DateTime.now().toIso8601String(),
    });
  }

  Future<void> endBreak(String breakId) async {
    await _supabase.from('attendance_breaks').update({
      'end_time': DateTime.now().toIso8601String(),
    }).eq('id', breakId);
  }
}
