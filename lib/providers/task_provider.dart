import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier()
      : super([
          Task(
            id: '1',
            title: '10 min Running',
            isCompleted: true,
            categoryId: '2',
            date: DateTime.now(),
          ),
          Task(
            id: '2',
            title: '5 min Rope Skipping',
            isCompleted: true,
            categoryId: '2',
            date: DateTime.now(),
          ),
          Task(
            id: '3',
            title: '10 Push ups',
            categoryId: '2',
            date: DateTime.now().add(const Duration(days: 1)),
          ),
        ]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void toggleTask(String taskId) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(isCompleted: !task.isCompleted)
        else
          task,
    ];
  }

  void deleteTask(String taskId) {
    state = state.where((task) => task.id != taskId).toList();
  }
}
