import 'package:fuck/models/category.dart';

enum CategoryData { escaaj, romizi, farshite, creativity }

extension CategoryDataExtension on CategoryData {
  String get persianTitle {
    switch (this) {
      case CategoryData.escaaj:
        return 'اسکاج';
      case CategoryData.romizi:
        return 'رومیزی';
      case CategoryData.farshite:
        return 'فرشینه';
      case CategoryData.creativity:
        return 'خلاقیت';
    }
  }

  String get image {
    switch (this) {
      case CategoryData.escaaj:
        return 'assets/images/escaj.jpg';
      case CategoryData.romizi:
        return 'assets/images/romizi.webp';
      case CategoryData.farshite:
        return 'assets/images/farshine.jpg';
      case CategoryData.creativity:
        return 'assets/images/creativity.jpg';
    }
  }

  Category get asCategory => Category(title: persianTitle, image: image);
}
