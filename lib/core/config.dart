class AppConfig {
  static const String version = '1.0.0';
  static const String environment = 'production';

  // Feature Flags
  // These would typically be fetched from Supabase 'client_configs' table
  static const bool enableFaceID = true;
  static const bool enableGeofencing = true;
  static const bool enablePayroll = true;
  static const bool enableAnalytics = true;
  static const bool enableShifts = true;

  // Plan Type
  // 'basic', 'pro', 'enterprise'
  static const String currentPlan = 'pro';

  static bool isFeatureEnabled(String feature) {
    switch (feature) {
      case 'payroll': return enablePayroll && (currentPlan == 'pro' || currentPlan == 'enterprise');
      case 'analytics': return enableAnalytics && (currentPlan == 'pro' || currentPlan == 'enterprise');
      case 'face_id': return enableFaceID;
      case 'geofence': return enableGeofencing;
      default: return false;
    }
  }
}
