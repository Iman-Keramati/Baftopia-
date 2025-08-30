import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'baftopia';
  static const String appDescription = 'Where Every Stitch Tells a Story';

  // Colors
  static const Color primaryColor = Color(0xFFD8A7B1);
  static const Color secondaryColor = Color(0xFFF7D6C3);
  static const Color backgroundColor = Color(0xFFFBEAE5);
  static const Color surfaceColor = Color(0xFFFFEDE7);
  static const Color textColor = Color(0xFF5E4A47);
  static const Color hintColor = Color(0xFFBFAAA0);

  // Fonts
  static const String persianFont = 'Vazirmatn';
  static const String englishFont = 'Poppins';

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Image Sizes
  static const double imageSizeSmall = 100.0;
  static const double imageSizeMedium = 250.0;
  static const double imageSizeLarge = 350.0;

  // Text Sizes
  static const double textSizeSmall = 14.0;
  static const double textSizeMedium = 16.0;
  static const double textSizeLarge = 20.0;
  static const double textSizeXLarge = 24.0;
  static const double textSizeXXLarge = 32.0;
}

class AppTexts {
  // Common
  static const String add = 'افزودن';
  static const String edit = 'ویرایش';
  static const String delete = 'حذف';
  static const String cancel = 'انصراف';
  static const String save = 'ذخیره';
  static const String loading = 'در حال بارگذاری...';
  static const String error = 'خطا';
  static const String success = 'موفقیت';

  // Categories
  static const String addCategory = 'افزودن دسته‌بندی';
  static const String editCategory = 'ویرایش دسته‌بندی';
  static const String categoryTitle = 'عنوان دسته‌بندی';
  static const String categoryAdded = 'دسته‌بندی با موفقیت افزوده شد';
  static const String categoryEdited = 'دسته‌بندی با موفقیت ویرایش شد';
  static const String categoryDeleted = 'دسته‌بندی با موفقیت حذف شد';
  static const String deleteCategoryConfirm =
      'آیا مطمئن هستید که می‌خواهید این دسته‌بندی را حذف کنید؟\n\nتوجه: تمام محصولات این دسته‌بندی نیز حذف خواهند شد.';

  // Products
  static const String addProduct = 'افزودن بافتنی';
  static const String editProduct = 'ویرایش بافتنی';
  static const String productName = 'نام';
  static const String productDescription = 'توضیحات';
  static const String productTimeSpent = 'زمان صرف شده';
  static const String productDifficulty = 'سطح دشواری';
  static const String productCategory = 'دسته بندی';
  static const String productDate = 'تاریخ پایان';
  static const String productImage = 'تصویر محصول';
  static const String productAdded = 'بافتنی با موفقیت افزوده شد';
  static const String productEdited = 'بافتنی با موفقیت ویرایش شد';
  static const String productDeleted = 'محصول با موفقیت حذف شد';
  static const String deleteProductConfirm =
      'آیا مطمئن هستید که می‌خواهید این محصول را حذف کنید؟';

  // Validation
  static const String requiredField = 'این فیلد الزامی است';
  static const String selectImage = 'لطفا تصویر محصول را انتخاب کنید';
  static const String selectCategory = 'لطفا دسته بندی را انتخاب کنید';
  static const String enterName = 'لطفا نام محصول را وارد کنید';
  static const String enterTimeSpent = 'لطفا زمان صرف شده را وارد کنید';
  static const String enterCategoryTitle = 'لطفاً عنوان دسته بندی را وارد کنید';

  // Errors
  static const String uploadError = 'خطا در بارگذاری تصویر';
  static const String networkError = 'خطا در ارتباط با سرور';
  static const String unknownError = 'خطای غیرمنتظره';
}
