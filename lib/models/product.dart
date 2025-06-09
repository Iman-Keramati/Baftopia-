import 'package:baftopia/models/category.dart';

class ProductModel {
  final String id;
  final String title;
  final String image;
  final DateTime date;
  final String timeSpent;
  final String difficultyLevel;
  final String description;
  final Category category;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.timeSpent,
    required this.difficultyLevel,
    required this.description,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      date: DateTime.parse(json['date']),
      timeSpent: json['time_spent'],
      difficultyLevel: json['difficulty_level'],
      description: json['description'] ?? '',
      category: Category.fromJson(json['categories'] as Map<String, dynamic>),
    );
  }
}
