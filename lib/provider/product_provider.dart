import 'package:Baftopia/data/product_data.dart';
import 'package:Baftopia/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = FutureProvider<List<ProductModel>>((ref) async {
  final service = ProductService();
  return service.getProducts();
});
