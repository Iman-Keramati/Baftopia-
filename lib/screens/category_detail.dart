import 'package:flutter/material.dart';
import 'package:fuck/models/category.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(category.title)));
  }
}
