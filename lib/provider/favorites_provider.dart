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
    final user = _client.auth.currentUser;
    if (user == null) return;

    final response = await _client
        .from('favorites')
        .select('*, products(*, categories(*))')
        .eq('user_id', user.id);

    if (response is List) {
      state = response.map((e) => FavoriteModel.fromMap(e)).toList();
    }
  }

  Future<void> addFavorite(String productId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final inserted =
        await _client
            .from('favorites')
            .upsert({
              'user_id': user.id,
              'product_id': productId,
            }, onConflict: 'user_id,product_id')
            .select('*, products(*, categories(*))')
            .single();

    final newFav = FavoriteModel.fromMap(inserted);
    state = [...state, newFav];
  }

  Future<void> removeFavorite(String productId) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    // Optimistic update first
    state = state.where((f) => f.id != productId).toList();

    // Then persist to Supabase
    await _client
        .from('favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('product_id', productId);
  }

  Future<void> toggleFavorite(String productId) async {
    final alreadyFavorite = state.any((f) => f.id == productId);

    if (alreadyFavorite) {
      await removeFavorite(productId);
    } else {
      try {
        await addFavorite(productId);
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          // ignore duplicate insert, just reload
          await loadFavorites();
        } else {
          rethrow;
        }
      }
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
