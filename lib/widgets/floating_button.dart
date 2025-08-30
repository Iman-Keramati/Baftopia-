import 'package:flutter/material.dart';
import 'package:baftopia/utils/admin_checker.dart';

class FloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? tooltip;

  const FloatingButton({super.key, required this.onPressed, this.tooltip});

  @override
  Widget build(BuildContext context) {
    if (!AdminChecker.isAdmin()) return const SizedBox.shrink();

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip ?? 'افزودن',
      child: const Icon(Icons.add),
    );
  }
}
