import 'package:baftopia/models/category.dart';

class ProductModel {
  final String id;
  final String title;
  final String image;
  final DateTime startDate;
  final DateTime endDate;
  final String difficultyLevel;
  final String description;
  final Category category;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.difficultyLevel,
    required this.description,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      difficultyLevel: json['difficulty_level'],
      description: json['description'] ?? '',
      category: Category.fromJson(json['categories'] as Map<String, dynamic>),
    );
  }
}
