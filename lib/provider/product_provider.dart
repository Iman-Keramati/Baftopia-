// product_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/models/product.dart';
import 'package:fuck/data/category_data.dart';

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>(
  (ref) => ProductNotifier(),
);

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void addProduct(Product product) {
    state = [...state, product];
  }

  List<Product> getProductsByCategory(CategoryData category) {
    return state.where((p) => p.category == category).toList();
  }
}
