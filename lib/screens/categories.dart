import 'package:flutter/material.dart';
import 'package:fuck/data/category_data.dart';
import 'package:fuck/widgets/category_item.dart';
import 'package:fuck/widgets/floating_button.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingButton(),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Image.asset('assets/icons/Logo-icon.png', width: 50, height: 50),
            const Text(
              'Baftopia',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder:
            (context, child) => SlideTransition(
              position: Tween(
                begin: const Offset(0, 0.2),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            ),
        child: GridView(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          children:
              CategoryData.values
                  .map((e) => CategoryItem(category: e.asCategory))
                  .toList(),
        ),
      ),
    );
  }
}
