import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuck/models/category.dart';
import 'package:fuck/screens/category_detail.dart';
import 'package:transparent_image/transparent_image.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    void openCategory(Category category) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => CategoryDetailScreen(category: category),
        ),
      );
    }

    return InkWell(
      onTap: () {
        openCategory(category);
      },
      child: Card(
        clipBehavior: Clip.antiAlias, // Prevent overflow
        child: SizedBox(
          height: 300,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(category.image),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black54,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
