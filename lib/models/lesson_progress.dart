class LessonProgress {
  final int total;
  final int completed;

  LessonProgress({required this.total, required this.completed});

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      total: json['total'],
      completed: json['completed'],
    );
  }

  double get progress => completed / total;
}
