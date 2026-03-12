import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class TaskService {
  final _supabase = Supabase.instance.client;

  Stream<List<Task>> getAssignedTasks(String userId) {
    return _supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('assigned_to', userId)
        .order('deadline', ascending: true)
        .map((data) => data.map((json) => Task.fromJson(json)).toList());
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    await _supabase
        .from('tasks')
        .update({'status': status})
        .eq('id', taskId);
  }
}
