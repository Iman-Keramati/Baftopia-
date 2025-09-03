import 'package:baftopia/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  final bool embedded;

  const FavoritesScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    final content =
        favorites.isEmpty
            ? const Center(
              child: Text(
                'بافتنی ای هنوز به دلت ننشسته',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
            : Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  return ProductCard(product: item);
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
            );

    if (embedded) return content;

    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text('علاقه مندی ها'),
        ),
        centerTitle: false,
      ),
      body: content,
    );
  }
}
