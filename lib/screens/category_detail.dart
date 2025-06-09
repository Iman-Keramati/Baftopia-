import 'package:baftopia/models/category.dart';
import 'package:baftopia/provider/product_provider.dart';
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
      floatingActionButton: FloatingButton(),
    );
  }
}
