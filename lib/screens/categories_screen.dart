import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/category_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/add_category_dialog.dart';
import '../models/category.dart';
import '../providers/auth_provider.dart';
import '../providers/quote_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(authProvider);
    if (!isAuthenticated) {
      return const SizedBox.shrink();
    }

    final categories = ref.watch(categoryProvider);
    final quote = ref.watch(quoteProvider);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.push('/settings'),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: ref.watch(userProvider).photoUrl != null
                  ? NetworkImage(ref.watch(userProvider).photoUrl!)
                  : null,
              child: ref.watch(userProvider).photoUrl == null
                  ? Text(ref.watch(userProvider).name[0].toUpperCase())
                  : null,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quote Card
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        'https://images.app.goo.gl/tREsKqEgfNC8KvEm7',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${quote.text}"',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            quote.author,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Categories Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddCategoryCard(context);
                }
                final category = categories[index - 1];
                return _buildCategoryCard(context, category);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryCard(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const AddCategoryDialog(),
          );
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 32),
            SizedBox(height: 8),
            Text('Add Category'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return Card(
      child: InkWell(
        onTap: () => context.push('/category/${category.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const Spacer(),
                  Text('${category.taskCount} tasks'),
                ],
              ),
              const Spacer(),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
