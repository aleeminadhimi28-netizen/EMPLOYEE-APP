import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import '../models/task_model.dart';

class TaskService {
  SupabaseClient get _supabase => Supabase.instance.client;

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

  Future<void> completeTaskWithImage(String taskId, Uint8List imageBytes) async {
    final fileName = 'proofs/$taskId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    
    // 1. Upload proof image to Supabase Storage
    await _supabase.storage.from('tasks').uploadBinary(fileName, imageBytes);
    
    // 2. Get public URL
    final imageUrl = _supabase.storage.from('tasks').getPublicUrl(fileName);
    
    // 3. Update task status and image URL
    await _supabase
        .from('tasks')
        .update({
          'status': 'completed',
          'image_url': imageUrl,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', taskId);
  }
}
