class TaskModel {
  final String title;
  final String subtitle;
  final String progressText;
  final double progress;

  TaskModel({
    required this.title,
    required this.subtitle,
    this.progressText = '',
    this.progress = 0.0,
  });

  // Converte de JSON para Objeto
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      progressText: json['progressText'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
    );
  }

  // Converte de Objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'progressText': progressText,
      'progress': progress,
    };
  }
}
