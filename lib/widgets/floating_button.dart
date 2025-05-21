import 'package:flutter/material.dart';
import 'package:fuck/widgets/add_product.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    void openDialog() {
      showModalBottomSheet(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Text('افزودن بافتنی'),
              ),
              titlePadding: EdgeInsets.only(bottom: 24),
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
      onPressed: openDialog,
      child: const Icon(Icons.add),
    );
  }
}
