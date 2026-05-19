class TaskStep {
  final String title;
  final bool isCompleted;
  final String? duration;
  final DateTime? completedAt;

  TaskStep({
    required this.title,
    this.isCompleted = false,
    this.duration,
    this.completedAt,
  });

  factory TaskStep.fromJson(Map<String, dynamic> json) {
    return TaskStep(
      title: json['title'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      duration: json['duration'],
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'duration': duration,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  TaskStep copyWith({
    String? title,
    bool? isCompleted,
    String? duration,
    DateTime? completedAt,
  }) {
    return TaskStep(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      duration: duration ?? this.duration,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
