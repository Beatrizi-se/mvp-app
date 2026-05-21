import 'task_step_model.dart';

class TaskModel {
  final String? id;
  final String title;
  final String subtitle;
  final String category;
  final String priority;
  final DateTime? date;
  final String? time;
  final List<TaskStep> steps;
  final bool isFavorite;

  TaskModel({
    this.id,
    required this.title,
    required this.subtitle,
    this.category = 'Selecionar',
    this.priority = 'Normal',
    this.date,
    this.time,
    this.steps = const [],
    this.isFavorite = false,
  });

  double get progress {
    if (steps.isEmpty) return 0.0;
    final completedCount = steps.where((s) => s.isCompleted).length;
    return completedCount / steps.length;
  }

  String get progressText {
    if (steps.isEmpty) return 'Sem passos';
    final completedCount = steps.where((s) => s.isCompleted).length;
    return '$completedCount/${steps.length} passos';
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      category: json['category'] ?? 'Selecionar',
      priority: json['priority'] ?? 'Normal',
      date: DateTime.tryParse(json['date'] ?? ''),
      time: json['time'],
      steps: (json['steps'] as List? ?? [])
          .map((step) => step is String 
              ? TaskStep(title: step)
              : TaskStep.fromJson(step as Map<String, dynamic>))
          .toList(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'priority': priority,
      'date': date?.toIso8601String(),
      'time': time,
      'steps': steps.map((s) => s.toJson()).toList(),
      'isFavorite': isFavorite,
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? category,
    String? priority,
    DateTime? date,
    String? time,
    List<TaskStep>? steps,
    bool? isFavorite,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      date: date ?? this.date,
      time: time ?? this.time,
      steps: steps ?? this.steps,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
