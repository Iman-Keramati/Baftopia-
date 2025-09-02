import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/user_provider.dart';

class FloatingButton extends ConsumerWidget {
  final VoidCallback onPressed;
  final String? tooltip;

  const FloatingButton({super.key, required this.onPressed, this.tooltip});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    // فقط وقتی لاگین و admin هست
    if (!userState.isLoggedIn || !userState.isAdmin)
      return const SizedBox.shrink();

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip ?? 'افزودن',
      child: const Icon(Icons.add),
    );
  }
}
