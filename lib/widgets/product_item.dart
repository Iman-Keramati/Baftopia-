import 'package:baftopia/models/product.dart';
import 'package:baftopia/provider/favorites_provider.dart';
import 'package:baftopia/screens/product_detail.dart';
import 'package:baftopia/utils/delete_product.dart';
import 'package:baftopia/widgets/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductItem extends ConsumerWidget {
  const ProductItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Difficulty difficultyFromString(String value) {
      return Difficulty.values.firstWhere(
        (d) => d.name == value,
        orElse: () => Difficulty.beginner,
      );
    }

    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((f) => f.id == product.id);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => ProductDetail(product: product)),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(product.image),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.access_time,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        product.timeSpent,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          difficultyFromString(product.difficultyLevel).icon,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          difficultyFromString(
                            product.difficultyLevel,
                          ).persianLabel,
                          style: TextStyle(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSecondaryContainer.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () async {
                    final user = Supabase.instance.client.auth.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'برای افزودن به علاقه‌مندی‌ها ابتدا وارد شوید',
                            textAlign: TextAlign.right,
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      return;
                    }
                    await ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(product.id);
                    final nowFavorite = ref
                        .read(favoritesProvider)
                        .any((f) => f.id == product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          nowFavorite
                              ? 'به علاقه‌مندی‌ها اضافه شد'
                              : 'از علاقه‌مندی‌ها حذف شد',
                          textAlign: TextAlign.right,
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) {
                        return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.8,
                          minChildSize: 0.3,
                          maxChildSize: 0.95,
                          builder:
                              (_, controller) => Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).dialogBackgroundColor,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: ListView(
                                  controller: controller,
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'ویرایش بافتنی',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            icon: const Icon(Icons.close),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    AddProduct(product: product),
                                  ],
                                ),
                              ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    deleteProductHandler(context, ref, product);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
