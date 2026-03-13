import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  final SupabaseClient _supabase;

  AttendanceService({SupabaseClient? client}) 
      : _supabase = client ?? Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAvailableSites() async {
    final response = await _supabase.from('work_sites').select();
    return List<Map<String, dynamic>>.from(response);
  }

  bool isWithinSite(Position currentPosition, Map<String, dynamic> site) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      site['latitude'],
      site['longitude'],
    );
    return distanceInMeters <= (site['radius_meters'] ?? 100.0);
  }

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

  Future<void> clockIn(String userId, int siteId) async {
    await _supabase.from('attendance').insert({
      'user_id': userId,
      'work_site_id': siteId,
      'check_in': DateTime.now().toIso8601String(),
      'status': 'present',
      'verified_via_face': true, // Assuming face was verified in UI
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
