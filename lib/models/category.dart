class Category {
  final String id;
  final String name;
  final String icon;
  final int taskCount;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.taskCount = 0,
  });
}
