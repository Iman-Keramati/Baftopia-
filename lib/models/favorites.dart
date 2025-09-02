import 'package:baftopia/models/category.dart';
import 'package:baftopia/models/product.dart';

class FavoriteModel extends ProductModel {
  final String favoriteId; // id داخل جدول favorites

  FavoriteModel({
    required this.favoriteId,
    required String id,
    required String title,
    required String description,
    required String image,
    required DateTime date,
    required String timeSpent,
    required String difficultyLevel,
    required Category category,
  }) : super(
         id: id,
         title: title,
         description: description,
         image: image,
         date: date,
         timeSpent: timeSpent,
         difficultyLevel: difficultyLevel,
         category: category,
       );

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    final product = (map['products'] ?? {}) as Map<String, dynamic>;
    return FavoriteModel(
      favoriteId: map['id'] as String,
      id: (product['id'] ?? map['product_id']) as String,
      title: (product['title'] ?? '') as String,
      description: (product['description'] ?? '') as String,
      image: (product['image'] ?? '') as String,
      date:
          product['date'] != null
              ? DateTime.parse(product['date'] as String)
              : DateTime.now(),
      timeSpent: (product['time_spent'] ?? '') as String,
      difficultyLevel: (product['difficulty_level'] ?? '') as String,
      category:
          product['categories'] != null
              ? Category.fromJson(product['categories'] as Map<String, dynamic>)
              : const Category(id: '', title: '', image: ''),
    );
  }
}
