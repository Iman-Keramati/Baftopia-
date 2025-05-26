import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuck/data/category_data.dart';
import 'package:fuck/models/category.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
      return CategoryNotifier();
    });

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier()
    : super([
        Category(
          title: CategoryData.creativity.persianTitle,
          image: CategoryData.creativity.image,
          isFromAsset: true,
        ),
        Category(
          title: CategoryData.escaaj.persianTitle,
          image: CategoryData.escaaj.image,
          isFromAsset: true,
        ),
        Category(
          title: CategoryData.farshite.persianTitle,
          image: CategoryData.farshite.image,
          isFromAsset: true,
        ),
        Category(
          title: CategoryData.romizi.persianTitle,
          image: CategoryData.romizi.image,
          isFromAsset: true,
        ),
      ]);

  void addCategory(Category category) {
    state = [...state, category];
  }
}
