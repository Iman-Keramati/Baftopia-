import 'dart:io';

import 'package:fuck/data/category_data.dart';
import 'package:fuck/models/category.dart';

enum Dificulty { beginner, regular, hard, extreme }

extension DificultyTranslation on Dificulty {
  String get title {
    switch (this) {
      case Dificulty.beginner:
        return 'مبتدی';
      case Dificulty.regular:
        return 'معمولی';
      case Dificulty.hard:
        return 'سخت';
      case Dificulty.extreme:
        return 'فوق‌سخت';
    }
  }
}

class Product {
  Product({
    required this.title,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.dificulty,
    required this.category,
  });

  final String title;
  final File image;
  final DateTime startDate;
  final DateTime endDate;
  final Dificulty dificulty;
  final CategoryData category;
}
