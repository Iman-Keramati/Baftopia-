import 'package:Baftopia/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  Future<void> addCategory(Category category) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('categories').insert({
      'id': category.id,
      'title': category.title,
      'image': category.image,
    });

    if (response == null || response.isEmpty) {
      throw Exception('Insert failed or returned empty');
    }
  }

  Future<List<Category>> getCategories() async {
    final supabase = Supabase.instance.client;
    try {
      final List<dynamic> response = await supabase.from('categories').select();
      return response.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
