import 'dart:async';
import 'package:baftopia/models/category.dart';
import 'package:baftopia/models/product.dart';

class AppUtils {
  /// Sort products by date (newest first)
  static List<ProductModel> sortProductsByDate(List<ProductModel> products) {
    final sortedProducts = List<ProductModel>.from(products);
    sortedProducts.sort((a, b) => b.date.compareTo(a.date));
    return sortedProducts;
  }

  /// Sort categories by creation time (assuming newer categories have higher IDs)
  /// In a real app, you might want to add a created_at field to categories
  static List<Category> sortCategoriesByCreation(List<Category> categories) {
    final sortedCategories = List<Category>.from(categories);
    // For now, we'll sort by ID (assuming newer categories have higher IDs)
    // In production, add a created_at field to the Category model
    sortedCategories.sort((a, b) => b.id.compareTo(a.id));
    return sortedCategories;
  }

  /// Format date for display
  static String formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate phone number format (Iranian)
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^(\+98|0)?9\d{9}$').hasMatch(phone);
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Generate initials from name
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  /// Check if string contains only numbers
  static bool isNumeric(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Debounce function for search
  static Function debounce(Function func, Duration wait) {
    Timer? timer;
    return (List<dynamic> args) {
      timer?.cancel();
      timer = Timer(wait, () => func(args));
    };
  }

  /// Throttle function for scroll events
  static Function throttle(Function func, Duration wait) {
    DateTime? lastRun;
    return (List<dynamic> args) {
      final now = DateTime.now();
      if (lastRun == null || now.difference(lastRun!) >= wait) {
        lastRun = now;
        func(args);
      }
    };
  }
}
