import 'package:baftopia/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesProvider extends StateNotifier<List<ProductModel>> {
  FavoritesProvider() : super([]);

  void addFavorite(ProductModel item) {
    if (!state.any((i) => i.id == item.id)) {
      state = [...state, item];
    }
  }

  void removeFavorite(String itemId) {
    state = state.where((i) => i.id != itemId).toList();
  }

  void toggleFavorite(ProductModel item) {
    if (state.any((i) => i.id == item.id)) {
      removeFavorite(item.id);
    } else {
      addFavorite(item);
    }
  }

  void clearFavorites() {
    state = [];
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesProvider, List<ProductModel>>(
      (ref) => FavoritesProvider(),
    );
