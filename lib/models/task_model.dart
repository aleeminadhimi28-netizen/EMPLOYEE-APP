import 'package:supabase_flutter/supabase_flutter.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String status; // 'pending', 'in-progress', 'completed'
  final DateTime? deadline;
  final String? assignedTo;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.deadline,
    this.assignedTo,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      status: json['status'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      assignedTo: json['assigned_to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'assigned_to': assignedTo,
    };
  }
}
