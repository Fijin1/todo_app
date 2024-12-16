import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/category_provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryDetailScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final category = categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => throw Exception('Category not found'),
    );
    final tasks = ref
        .watch(taskProvider)
        .where((task) => task.categoryId == categoryId)
        .toList();

    // Group tasks by date
    final groupedTasks = <String, List<Task>>{};
    for (var task in tasks) {
      final date = task.date;
      if (date == null) continue;

      final key = _getDateKey(date);
      if (!groupedTasks.containsKey(key)) {
        groupedTasks[key] = [];
      }
      groupedTasks[key]!.add(task);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedTasks.length,
        itemBuilder: (context, index) {
          final dateKey = groupedTasks.keys.elementAt(index);
          final tasksForDate = groupedTasks[dateKey]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  dateKey,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...tasksForDate.map((task) => _buildTaskItem(context, ref, task)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getDateKey(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == DateTime(now.year, now.month, now.day)) {
      return 'Today';
    } else if (taskDate == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildTaskItem(BuildContext context, WidgetRef ref, Task task) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task.isCompleted
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: task.isCompleted ? Colors.green : null,
          ),
          onPressed: () {
            ref.read(taskProvider.notifier).toggleTask(task.id);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ref.read(taskProvider.notifier).deleteTask(task.id);
          },
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Type your task...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final task = Task(
                  id: DateTime.now().toString(),
                  title: controller.text,
                  categoryId: categoryId,
                  date: DateTime.now(),
                );
                ref.read(taskProvider.notifier).addTask(task);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
