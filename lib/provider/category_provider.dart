import 'package:baftopia/core/utils.dart';
import 'package:baftopia/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/category_data.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final service = CategoryService();
  final categories = await service.getCategories();
  return AppUtils.sortCategoriesByCreation(categories);
});
