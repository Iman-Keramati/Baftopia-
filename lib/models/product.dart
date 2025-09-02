import 'package:baftopia/models/category.dart';

class ProductModel {
  final String id;
  final String title;
  final String image; // representative image
  final List<String> images; // new: all images
  final DateTime date;
  final String timeSpent;
  final String difficultyLevel;
  final String description;
  final Category category;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.images,
    required this.date,
    required this.timeSpent,
    required this.difficultyLevel,
    required this.description,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final dynamic imagesRaw = json['images'];
    final List<String> parsedImages =
        imagesRaw is List
            ? imagesRaw.map((e) => e.toString()).toList()
            : <String>[];

    return ProductModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      images: parsedImages,
      date: DateTime.parse(json['date']),
      timeSpent: json['time_spent'],
      difficultyLevel: json['difficulty_level'],
      description: json['description'] ?? '',
      category: Category.fromJson(json['categories'] as Map<String, dynamic>),
    );
  }
}
