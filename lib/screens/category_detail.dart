import 'package:flutter/material.dart';
import 'package:fuck/models/category.dart';
import 'package:fuck/models/product.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: const Text('بافتنی ای در این دسته بندی وجود ندارد'),
    );

    final products = ProductManager().getCategoryProducts(category);

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
                'مدت زمان بافت: ${product.startDate.difference(product.endDate).inHours} روز',
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      );
    }
    return Scaffold(appBar: AppBar(title: Text(category.title)), body: content);
  }
}
