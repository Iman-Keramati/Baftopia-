import 'package:fuck/models/category.dart';

enum Dificulty { beginer, regular, hard, extreme }

class Product {
  const Product({
    required this.title,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.dificulty,
    required this.category,
  });

  final String title;
  final String image;
  final DateTime startDate;
  final DateTime endDate;
  final Dificulty dificulty;
  final Category category;
}
