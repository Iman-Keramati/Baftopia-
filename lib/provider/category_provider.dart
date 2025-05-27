import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/models/category.dart';
import '../data/category_data.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final service = CategoryService();
  return service.getCategories();
});
