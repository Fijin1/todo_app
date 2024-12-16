class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? date;
  final String categoryId;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.date,
    required this.categoryId,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? date,
    String? categoryId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
