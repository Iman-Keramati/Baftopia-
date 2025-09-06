import 'package:baftopia/provider/category_provider.dart';
import 'package:baftopia/widgets/add_category.dart';
import 'package:baftopia/widgets/category_item.dart';
import 'package:baftopia/widgets/floating_button.dart';
import 'package:baftopia/widgets/side_menu.dart';
import 'package:baftopia/widgets/add_content_sheet.dart';
import 'package:baftopia/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/user_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  final bool embedded;

  const CategoriesScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final Widget body = categoriesAsync.when(
      data:
          (categories) =>
              categories.isNotEmpty
                  ? GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                        ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryItem(category: category);
                    },
                  )
                  : EmptyStateWidgets.categoriesEmpty(
                    onAddPressed: () async {
                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => AddCategory(modalContext: ctx),
                      );
                      if (result == true) {
                        ref.invalidate(categoryProvider);
                      }
                    },
                    showAction: true,
                  ),
      loading: () => EmptyStateWidgets.loadingState(),
      error: (error, stack) {
        print('Error: $error');
        return EmptyStateWidgets.errorState(
          errorMessage: 'خطا در بارگذاری دسته‌بندی‌ها',
          onRetryPressed: () => ref.invalidate(categoryProvider),
        );
      },
    );

    if (embedded) {
      return body;
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: const SideMenu(),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/Logo-icon.png', width: 50, height: 50),
            const SizedBox(width: 8),
            const Text(
              'baftopia',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final userState = ref.watch(userProvider);
              if (userState.isAdmin) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final result = await showModalBottomSheet<bool>(
                      context: context,
                      isScrollControlled: true,
                      builder: (ctx) => AddCategory(modalContext: ctx),
                    );
                    if (result == true) {
                      ref.invalidate(categoryProvider);
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const AddContentSheet(),
          );
        },
        tooltip: 'افزودن بافتنی جدید',
      ),
      body: body,
    );
  }
}
