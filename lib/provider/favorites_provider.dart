import 'package:baftopia/models/favorites.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_provider.dart';

class FavoritesProvider extends StateNotifier<List<FavoriteModel>> {
  FavoritesProvider(this.ref) : super([]) {
    ref.listen<UserState>(userProvider, (previous, next) {
      if (next.isLoggedIn) {
        loadFavorites();
      } else {
        clearFavorites();
      }
    });
  }

  final Ref ref;
  final _client = Supabase.instance.client;

  Future<void> loadFavorites() async {
    final userState = ref.read(userProvider);
    if (!userState.isLoggedIn) return;

    final user = _client.auth.currentUser;
    if (user == null) return;

    final response = await _client
        .from('favorites')
        .select()
        .eq('user_id', user.id);

    final data = response as List<dynamic>;
    state = data.map((e) => FavoriteModel.fromMap(e)).toList();
  }

  Future<void> addFavorite(String productId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('favorites').insert({
      'user_id': user.id,
      'product_id': productId,
    });

    await loadFavorites();
  }

  Future<void> removeFavorite(String productId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client
        .from('favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('product_id', productId);

    await loadFavorites();
  }

  /// 🔥 New method to toggle on/off favorites
  Future<void> toggleFavorite(String productId) async {
    final isAlreadyFavorite = state.any(
      (favorite) => favorite.favoriteId == productId,
    );

    if (isAlreadyFavorite) {
      await removeFavorite(productId);
    } else {
      await addFavorite(productId);
    }
  }

  void clearFavorites() {
    state = [];
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesProvider, List<FavoriteModel>>(
      (ref) => FavoritesProvider(ref),
    );
