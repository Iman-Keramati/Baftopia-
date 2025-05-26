import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/data/category_data.dart';
import 'package:fuck/models/category.dart';
import 'package:fuck/models/product.dart';
import 'package:fuck/provider/product_provider.dart';
import 'package:fuck/widgets/floating_button.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = Center(
      child: const Text('بافتنی ای در این دسته بندی وجود ندارد'),
    );

    final products =
        ref
            .watch(productProvider)
            .where((prod) => prod.category.persianTitle == category.title)
            .toList();

    if (products.isNotEmpty) {
      content = Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.file(
                  product.image,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image);
                  },
                ),
              ),
              title: Text(product.title, style: TextStyle(fontSize: 20)),
              subtitle: Text(product.dificulty.title),
              trailing: Text(
                'مدت زمان بافت: ${product.endDate.difference(product.startDate).inDays < 1 ? '${product.endDate.difference(product.startDate).inHours} ساعت' : '${product.endDate.difference(product.startDate).inDays} روز'}',
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text(category.title)],
        ),
      ),
      body: content,
      floatingActionButton: FloatingButton(),
    );
  }
}
