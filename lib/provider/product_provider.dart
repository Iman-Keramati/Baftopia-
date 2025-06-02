import 'package:baftopia/data/product_data.dart';
import 'package:baftopia/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = FutureProvider<List<ProductModel>>((ref) async {
  final service = ProductService();
  return service.getProducts();
});
