import 'package:baftopia/widgets/add_category.dart';
import 'package:baftopia/widgets/add_product.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    void openCategoryDialog() {
      showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true, // KEY PART
        backgroundColor: Colors.transparent, // Optional for styling
        builder:
            (ctx) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(16),
                child: AddCategory(modalContext: ctx),
              ),
            ),
      );
    }

    void openProductDialog() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent, // Optional for rounded corners
        builder: (ctx) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.8, // 80% of screen height
            minChildSize: 0.3,
            maxChildSize: 0.95,
            builder:
                (_, controller) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.vertical(
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
                      const SizedBox(height: 16),
                      AddProduct(), // 👈 Your custom form/widget
                    ],
                  ),
                ),
          );
        },
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
