import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/models/category.dart';
import 'package:fuck/provider/product_provider.dart';
import 'package:fuck/utils/persian_number.dart';
import 'package:fuck/widgets/floating_button.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text(category.title)],
        ),
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) =>
                Center(child: Text('خطا در بارگذاری محصولات: $error')),
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Text('بافتنی ای در این دسته بندی وجود ندارد'),
            );
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final duration = product.endDate.difference(product.startDate);

                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.network(
                      product.image,
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(
                    product.title,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(product.difficultyLevel),
                  trailing: Text.rich(
                    TextSpan(
                      text: 'مدت زمان بافت: ',
                      children: [
                        TextSpan(
                          text:
                              duration.inDays < 1
                                  ? '${PersianNumber.toPersian(duration.inHours.toString())} ساعت'
                                  : '${PersianNumber.toPersian(duration.inDays.toString())} روز',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
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
