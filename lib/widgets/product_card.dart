import 'package:baftopia/models/product.dart';
import 'package:baftopia/provider/favorites_provider.dart';
import 'package:baftopia/screens/product_detail.dart';
import 'package:baftopia/utils/delete_product.dart';
import 'package:baftopia/widgets/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({super.key, required this.product});

  final ProductModel product;

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _expanded = false;

  Difficulty difficultyFromString(String value) {
    return Difficulty.values.firstWhere(
      (d) => d.name == value,
      orElse: () => Difficulty.beginner,
    );
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    setState(() {
      _expanded = true;
    });
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _expanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((f) => f.id == widget.product.id);

    return GestureDetector(
      onLongPressStart: _handleLongPressStart,
      onLongPressEnd: _handleLongPressEnd,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ProductDetail(product: widget.product),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background image
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(widget.product.image),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),

            // Top-right action badges
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  _ActionBadge(
                    icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                    color:
                        isFavorite
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary,
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
                          .toggleFavorite(widget.product.id);
                      final nowFavorite = ref
                          .read(favoritesProvider)
                          .any((f) => f.id == widget.product.id);
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
                  const SizedBox(width: 6),
                  _ActionBadge(
                    icon: Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () async {
                      await showModalBottomSheet(
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
                                      AddProduct(product: widget.product),
                                    ],
                                  ),
                                ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  _ActionBadge(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () {
                      deleteProductHandler(context, ref, widget.product);
                    },
                  ),
                ],
              ),
            ),

            // Bottom scrim with title and expandable meta
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child:
                          _expanded
                              ? Padding(
                                key: const ValueKey('meta'),
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            difficultyFromString(
                                              widget.product.difficultyLevel,
                                            ).icon,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            difficultyFromString(
                                              widget.product.difficultyLevel,
                                            ).persianLabel,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                      ],
                                    ),
                                    Text(
                                      widget.product.timeSpent,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBadge extends StatelessWidget {
  const _ActionBadge({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
