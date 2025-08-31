import 'package:baftopia/models/category.dart';
import 'package:baftopia/models/product.dart';

class FavoriteModel extends ProductModel {
  final String favoriteId; // id داخل جدول favorites

  FavoriteModel({
    required this.favoriteId,
    required String id,
    required String title,
    required String description,
    required double price,
    required String image,
    required DateTime date,
    required String timeSpent,
    required String difficultyLevel,
    required Category category,
    // بقیه فیلدهای Product...
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
    return FavoriteModel(
      favoriteId: map['id'], // id جدول favorites
      id: map['product_id'], // id محصول
      title: map['products']?['title'] ?? '',
      description: map['products']?['description'] ?? '',
      price: (map['products']?['price'] ?? 0).toDouble(),
      image: map['products']?['image'] ?? '',
      date: map['products']?['date'] ?? '',
      timeSpent: map['products']?['timeSpent'] ?? '',
      difficultyLevel: map['products']?['difficultyLevel'] ?? '',
      category: map['products']?['category'] ?? '',
    );
  }
}
