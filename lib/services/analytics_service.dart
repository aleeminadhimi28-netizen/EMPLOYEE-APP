import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getProductivityStats() async {
    try {
      // 1. Fetch task completion count vs total tasks
      final tasksResponse = await _supabase.from('tasks').select('status');
      final tasksList = (tasksResponse as List);
      int completed = tasksList.where((t) => t['status'] == 'completed').length;
      int total = tasksList.length;

      // 2. Fetch attendance trends (Simplified mock data for visualization)
      // In a real app, you'd perform a group-by query via a dynamic Edge Function
      
      return {
        'completionRate': total > 0 ? (completed / total) * 100 : 0,
        'totalTasks': total,
        'completedTasks': completed,
        'activeEmployees': 12,
        'attendanceHeatmap': [15, 20, 18, 22, 19, 25, 14], // Last 7 days headcount
        'taskTrends': [5, 8, 12, 7, 10, 15, 9], // Completed per day
      };
    } catch (e) {
      print('Analytics error: $e');
      return {};
    }
  }
}
