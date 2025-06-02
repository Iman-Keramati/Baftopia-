import 'package:baftopia/provider/category_provider.dart';
import 'package:baftopia/widgets/add_category.dart';
import 'package:baftopia/widgets/category_item.dart';
import 'package:baftopia/widgets/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);

    return Scaffold(
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await showModalBottomSheet<bool>(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => AddCategory(modalContext: ctx), // just this
              );

              if (result == true) {
                ref.invalidate(
                  categoryProvider,
                ); // or trigger via notifier if you use StateNotifier
              }
            },
          ),
        ],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/Logo-icon.png', width: 50, height: 50),
            const SizedBox(width: 8),
            const Text(
              'baftopia',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
      ),
      body: categoriesAsync.when(
        data:
            (categories) =>
                categories.isNotEmpty
                    ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryItem(category: category);
                      },
                    )
                    : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'هیچ دسته بندی وجود ندارد',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'برای افزودن دسته‌بندی جدید، روی دکمه + بالای صفحه بزنید',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          print('Error: $error');
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
