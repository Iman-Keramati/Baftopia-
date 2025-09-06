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
import 'package:baftopia/provider/user_provider.dart';

class ProductDetail extends ConsumerStatefulWidget {
  const ProductDetail({super.key, required this.product});

  final ProductModel product;

  @override
  ConsumerState<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends ConsumerState<ProductDetail> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Difficulty difficultyFromString(String value) {
      return Difficulty.values.firstWhere(
        (d) => d.name == value,
        orElse: () => Difficulty.beginner,
      );
    }

    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((item) => item.id == widget.product.id);
    print('is favorite$isFavorite');
    final userState = ref.watch(userProvider);

    final images =
        widget.product.images.isNotEmpty
            ? widget.product.images
            : [widget.product.image];

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
                  .toggleFavorite(widget.product.id);
              final nowFavorite = ref
                  .read(favoritesProvider)
                  .any((item) => item.id == widget.product.id);
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
          if (userState.isAdmin)
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
                                AddProduct(product: widget.product),
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
          if (userState.isAdmin)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed:
                  () => deleteProductHandler(context, ref, widget.product),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
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
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: images.length,
                          itemBuilder:
                              (_, i) => FadeInImage(
                                placeholder: MemoryImage(kTransparentImage),
                                image: NetworkImage(images[i]),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                        ),
                      ),
                    ),
                  ),
                  if (images.length > 1) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentPage == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
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
                          difficultyFromString(
                            widget.product.difficultyLevel,
                          ).icon,
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          difficultyFromString(
                            widget.product.difficultyLevel,
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
                    widget.product.title,
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
                      Text(widget.product.date.toJalali().formatFullDate()),
                      Icon(Icons.calendar_month),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('مدت زمان بافت:  ${widget.product.timeSpent}'),
                      Icon(Icons.timer_rounded),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(widget.product.description),
            ],
          ),
        ),
      ),
    );
  }
}
