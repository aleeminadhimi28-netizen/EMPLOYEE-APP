import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';
import '../../models/task_model.dart';
import '../../services/task_service.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _service = TaskService();
  final _userId = Supabase.instance.client.auth.currentUser?.id;

  @override
  Widget build(BuildContext context) {
    if (_userId == null) return const Scaffold(body: Center(child: Text('Please login')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<List<Task>>(
        stream: _service.getAssignedTasks(_userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tasks.length,
            itemBuilder: (context, index) => _buildTaskCard(tasks[index]),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.clipboardCheck, size: 64, color: AppTheme.textSecondary.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('No tasks assigned yet', style: TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    Color statusColor;
    switch (task.status) {
      case 'completed': statusColor = Colors.green; break;
      case 'in-progress': statusColor = Colors.orange; break;
      default: statusColor = AppTheme.primary;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.status.toUpperCase(),
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                if (task.deadline != null)
                  Text(
                    DateFormat('MMM dd, yyyy').format(task.deadline!),
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              task.description,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            if (task.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  task.imageUrl!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (task.status != 'completed')
                  TextButton.icon(
                    onPressed: () async {
                      if (task.status == 'todo') {
                         await _service.updateTaskStatus(task.id, 'in-progress');
                      } else {
                        // Complete with image
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          final bytes = await image.readAsBytes();
                          await _service.completeTaskWithImage(task.id, bytes);
                        }
                      }
                    },
                    icon: Icon(task.status == 'todo' ? LucideIcons.play : LucideIcons.checkCheck, size: 16),
                    label: Text(task.status == 'todo' ? 'Start Task' : 'Submit Proof'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
