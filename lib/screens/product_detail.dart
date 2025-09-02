import 'package:baftopia/models/product.dart';
import 'package:baftopia/provider/favorites_provider.dart';
import 'package:baftopia/utils/delete_product.dart';
import 'package:baftopia/widgets/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jalali_date_picker/flutter_jalali_date_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetail extends ConsumerWidget {
  const ProductDetail({super.key, required this.product});

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
    final isFavorite = favorites.any((item) => item.id == product.id);
    print('is favorite$isFavorite');

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
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
                  .any((item) => item.id == product.id);
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
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedProduct = await showModalBottomSheet<ProductModel>(
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
                            color: Theme.of(context).dialogBackgroundColor,
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
                                      onPressed: () => Navigator.pop(context),
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

              if (updatedProduct != null) {
                // If we got an updated product, pop the detail screen and push a new one
                // This ensures the UI is updated with the new data
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ProductDetail(product: updatedProduct),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => deleteProductHandler(context, ref, product),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 350,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: NetworkImage(product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          difficultyFromString(product.difficultyLevel).icon,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                          size: 20,
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
                  Text(
                    product.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(product.date.toJalali().formatFullDate()),
                      Icon(Icons.calendar_month),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('مدت زمان بافت:  ${product.timeSpent}'),
                      Icon(Icons.timer_rounded),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(product.description),
            ],
          ),
        ),
      ),
    );
  }
}
