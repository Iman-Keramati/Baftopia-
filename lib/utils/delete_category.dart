import 'package:baftopia/data/category_data.dart';
import 'package:baftopia/models/category.dart';
import 'package:baftopia/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void deleteCategoryHandler(
  BuildContext context,
  WidgetRef ref,
  Category category,
) {
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('حذف دسته‌بندی'),
                ),
                content: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'آیا مطمئن هستید که می‌خواهید این دسته‌بندی را حذف کنید؟\n\nتوجه: تمام محصولات این دسته‌بندی نیز حذف خواهند شد.',
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
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed:
                              isLoading
                                  ? null
                                  : () async {
                                    setState(() => isLoading = true);
                                    try {
                                      await CategoryService().removeCategory(
                                        category.id,
                                      );
                                      await ref.refresh(
                                        categoryProvider.future,
                                      );
                                      if (!context.mounted) return;
                                      Navigator.pop(context);
                                      Navigator.pop(context, true);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'دسته‌بندی با موفقیت حذف شد.',
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
                                            'خطا هنگام حذف دسته‌بندی: $e',
                                          ),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  },
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
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
