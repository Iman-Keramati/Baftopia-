import 'package:baftopia/models/category.dart';
import 'package:baftopia/widgets/add_category.dart';
import 'package:baftopia/widgets/add_product.dart';
import 'package:flutter/material.dart';

class AddContentSheet extends StatelessWidget {
  const AddContentSheet({super.key, this.initialCategory});

  final Category? initialCategory;

  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'افزودن بافتنی جدید',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder:
                                (ctx) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(ctx).viewInsets.bottom,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(
                                            context,
                                          ).dialogBackgroundColor,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: AddCategory(modalContext: ctx),
                                  ),
                                ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('افزودن دسته‌بندی'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AddProduct(initialCategory: initialCategory),
              ],
            ),
          ),
    );
  }
}
