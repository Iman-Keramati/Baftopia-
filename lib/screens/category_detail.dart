import 'package:baftopia/models/category.dart';
import 'package:baftopia/provider/product_provider.dart';
import 'package:baftopia/utils/delete_category.dart';
import 'package:baftopia/widgets/add_category.dart';
import 'package:baftopia/widgets/add_content_sheet.dart';
import 'package:baftopia/widgets/floating_button.dart';
import 'package:baftopia/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:baftopia/provider/user_provider.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text(category.title)],
        ),
        actions: [
          if (userState.isAdmin)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final updatedCategory = await showModalBottomSheet<Category>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) {
                    return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.8,
                      minChildSize: 0.3,
                      maxChildSize: 0.95,
                      builder:
                          (_, controller) => Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).dialogBackgroundColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: ListView(
                              controller: controller,
                              children: [
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'ویرایش دسته‌بندی',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AddCategory(category: category),
                              ],
                            ),
                          ),
                    );
                  },
                );

                if (updatedCategory != null) {
                  // If we got an updated category, pop the detail screen and push a new one
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (ctx) =>
                              CategoryDetailScreen(category: updatedCategory),
                    ),
                  );
                }
              },
            ),
          if (userState.isAdmin)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteCategoryHandler(context, ref, category),
            ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          return Center(child: Text('خطا در بارگذاری محصولات: $error'));
        },
        data: (products) {
          final filteredProducts =
              products.where((p) => p.category.id == category.id).toList();
          if (filteredProducts.isEmpty) {
            return const Center(
              child: Text('بافتنی ای در این دسته بندی وجود ندارد'),
            );
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return ProductCard(product: product);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => AddContentSheet(initialCategory: category),
          );
        },
        tooltip: 'افزودن بافتنی جدید',
      ),
    );
  }
}
