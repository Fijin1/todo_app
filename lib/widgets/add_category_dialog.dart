import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';

class AddCategoryDialog extends ConsumerWidget {
  const AddCategoryDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final iconController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: iconController,
            decoration: const InputDecoration(
              labelText: 'Icon (emoji)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                iconController.text.isNotEmpty) {
              final category = Category(
                id: DateTime.now().toString(),
                name: nameController.text,
                icon: iconController.text,
              );
              ref.read(categoryProvider.notifier).addCategory(category);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
