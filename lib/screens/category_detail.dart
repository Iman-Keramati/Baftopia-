import 'package:Baftopia/models/category.dart';
import 'package:Baftopia/provider/product_provider.dart';
import 'package:Baftopia/utils/persian_number.dart';
import 'package:Baftopia/widgets/add_product.dart';
import 'package:Baftopia/widgets/floating_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

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
          print(error);
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
                final duration = product.endDate.difference(product.startDate);

                return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(
                          33,
                          88,
                          81,
                          81,
                        ), // soft and subtle
                        offset: Offset(0, 2), // only at the bottom
                        blurRadius: 4, // smooth blur
                        spreadRadius: 0,
                        // tight and controlled
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: ListTile(
                    style: ListTileStyle.list,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(product.image),
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      difficultyFromString(
                        product.difficultyLevel,
                      ).persianLabel,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
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
