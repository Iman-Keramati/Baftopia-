import 'package:Baftopia/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/category_data.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final service = CategoryService();
  return await service.getCategories();
});
