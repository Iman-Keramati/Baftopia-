import 'package:baftopia/data/product_data.dart';
import 'package:baftopia/models/product.dart';
import 'package:baftopia/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void deleteProductHandler(
  BuildContext context,
  WidgetRef ref,
  ProductModel product,
) {
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false, // prevent dismiss during loading
    builder:
        (context) => StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('حذف محصول'),
                ),
                content: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'آیا مطمئن هستید که می‌خواهید این محصول را حذف کنید؟',
                  ),
                ),
                actions: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed:
                              isLoading ? null : () => Navigator.pop(context),
                          child: const Text('انصراف'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                          ),
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    setState(() => isLoading = true);
                                    try {
                                      await ProductService().removeProduct(
                                        product.id,
                                      );
                                      await ref.refresh(productProvider.future);
                                      if (!context.mounted) return;
                                      Navigator.pop(context); // close dialog
                                      Navigator.pop(
                                        context,
                                        true,
                                      ); // close detail page and return true
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'محصول با موفقیت حذف شد.',
                                          ),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    } catch (e) {
                                      setState(() => isLoading = false);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'خطا هنگام حذف محصول: $e',
                                          ),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                          child:
                              isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                    ),
                                  )
                                  : const Text('حذف'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ),
  );
}
