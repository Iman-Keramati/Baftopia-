import 'package:baftopia/models/category.dart';
import 'package:baftopia/provider/product_provider.dart';
import 'package:baftopia/utils/delete_category.dart';
import 'package:baftopia/widgets/add_category.dart';
import 'package:baftopia/widgets/add_product.dart';
import 'package:baftopia/widgets/floating_button.dart';
import 'package:baftopia/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);

    Difficulty difficultyFromString(String value) {
      return Difficulty.values.firstWhere(
        (d) => d.name == value,
        orElse: () => Difficulty.beginner,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text(category.title)],
        ),
        actions: [
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
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ProductItem(product: product),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            ),
          );
        },
      ),
      floatingActionButton: FloatingButton(
        onPressed: () async {
          final newProduct = await Navigator.of(
            context,
          ).pushNamed('/add-product', arguments: category);
          if (newProduct != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('محصول جدید اضافه شد')),
            );
            ref.invalidate(productProvider);
          }
        },
        tooltip: 'افزودن بافتنی جدید',
      ),
    );
  }
}
