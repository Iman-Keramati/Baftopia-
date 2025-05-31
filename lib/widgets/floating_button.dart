import 'package:Baftopia/widgets/add_category.dart';
import 'package:Baftopia/widgets/add_product.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    void openCategoryDialog() {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text('افزودن دسته بندی جدید'),
              content: AddCategory(),
            ),
      );
    }

    void openProductDialog() {
      showModalBottomSheet(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'بافتنی جدید',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                      ),
                      onPressed: openCategoryDialog,
                      icon: Icon(Icons.add),
                      label: Text('افزودن دسته بندی'),
                    ),
                  ],
                ),
              ),
              titlePadding: EdgeInsets.only(bottom: 12),
              content: AddProduct(),
              contentPadding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
      );
    }

    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      onPressed: openProductDialog,
      child: const Icon(Icons.add),
    );
  }
}
