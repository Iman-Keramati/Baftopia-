import 'package:baftopia/provider/category_provider.dart';
import 'package:baftopia/provider/user_provider.dart';
import 'package:baftopia/screens/about_us.dart';
import 'package:baftopia/screens/categories.dart';
import 'package:baftopia/screens/favorites.dart';
import 'package:baftopia/screens/profile.dart';
import 'package:baftopia/widgets/add_category.dart';
import 'package:baftopia/widgets/add_content_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  Future<void> _openWhatsApp() async {
    const String message = 'Hi! I’d like to order a handmade product.';
    final Uri whatsappUri = Uri.parse(
      'whatsapp://send?text=${Uri.encodeComponent(message)}',
    );
    final Uri webUri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    final List<Widget> pages = <Widget>[
      const CategoriesScreen(embedded: true),
      const FavoritesScreen(embedded: true),
      const AboutUsScreen(),
      const ProfileScreen(),
    ];

    final titles = <String>['خانه', 'علاقه‌مندی‌ها', 'درباره ما', 'پروفایل'];

    // Page-specific actions for AppBar
    List<Widget> buildActions() {
      if (_currentIndex == 0 && userState.isAdmin) {
        return [
          IconButton(
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
          ),
        ];
      }
      return const [];
    }

    // Page-specific FAB (admin content add) only on Home tab
    Widget? buildPageFab() {
      if (_currentIndex == 0 && userState.isAdmin) {
        return FloatingActionButton(
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (ctx) => const AddContentSheet(),
            );
          },
          tooltip: 'افزودن بافتنی جدید',
          child: const Icon(Icons.add),
        );
      }
      return null;
    }

    final pageFab = buildPageFab();

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        centerTitle: true,
        actions: buildActions(),
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'خانه'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'علاقه‌مندی‌ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'درباره ما',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'پروفایل',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (pageFab != null) pageFab,
          if (pageFab != null) const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'whatsapp_fab',
            onPressed: _openWhatsApp,
            tooltip: 'Order via WhatsApp',
            backgroundColor: const Color(0xFF25D366),
            child: const Icon(Icons.chat),
          ),
        ],
      ),
    );
  }
}
