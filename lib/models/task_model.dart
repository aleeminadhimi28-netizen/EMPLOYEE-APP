
class Task {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String status; // 'pending', 'in-progress', 'completed'
  final DateTime? deadline;
  final String? assignedTo;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.status,
    this.deadline,
    this.assignedTo,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task.fromMap(json);

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'].toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image_url'],
      status: map['status'] ?? 'todo',
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      assignedTo: map['assigned_to']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'assigned_to': assignedTo,
    };
  }
}
