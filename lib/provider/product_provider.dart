import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/data/product_data.dart';
import 'package:fuck/models/product.dart';

final productProvider = FutureProvider<List<ProductModel>>((ref) async {
  final service = ProductService();
  return service.getProducts();
});
