import 'package:flutter/material.dart';
import 'package:fuck/widgets/add_category.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    void openDialog() {
      showModalBottomSheet(
        context: context,
        builder:
            (ctx) => AlertDialog(
              content: AddCategory(),
              contentPadding: const EdgeInsets.all(20),
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
