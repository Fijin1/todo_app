import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  return CategoryNotifier();
});

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier()
      : super([
          Category(id: '1', name: 'Home', icon: '🏠', taskCount: 10),
          Category(id: '2', name: 'Sport', icon: '🏃', taskCount: 5),
          Category(id: '3', name: 'Homework', icon: '📚', taskCount: 13),
          Category(id: '4', name: 'E-learning', icon: '💻', taskCount: 4),
          Category(id: '5', name: 'Shopping', icon: '🛒', taskCount: 9),
          Category(id: '6', name: 'Food', icon: '🍔', taskCount: 1),
          Category(id: '7', name: 'Design', icon: '🎨', taskCount: 3),
        ]);

  void addCategory(Category category) {
    state = [...state, category];
  }

  void removeCategory(String id) {
    state = state.where((category) => category.id != id).toList();
  }

  void updateCategory(Category category) {
    state = state.map((c) => c.id == category.id ? category : c).toList();
  }
}
