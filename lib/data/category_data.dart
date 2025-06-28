import 'package:baftopia/models/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  Future<void> addCategory(Category category) async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase.from('categories').insert({
            'id': category.id,
            'title': category.title,
            'image': category.image,
          }).select(); // 👈 force return

      if (response.isEmpty) {
        throw Exception('Insert succeeded but returned empty result.');
      }
    } catch (e) {
      throw Exception('Insert failed: $e');
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

  Future<Category> updateCategory(Category category) async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase
              .from('categories')
              .update({'title': category.title, 'image': category.image})
              .eq('id', category.id)
              .select()
              .single();

      return Category.fromJson(response);
    } catch (e) {
      print('Error updating category: $e');
      throw Exception('خطا در ویرایش دسته‌بندی: $e');
    }
  }

  Future<void> removeCategory(String id) async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase
              .from('categories')
              .delete()
              .eq('id', id)
              .select()
              .single();

      if (response.isEmpty) {
        throw Exception('No data returned from Supabase.');
      }

      print('Category deleted: $response');
    } on PostgrestException catch (e) {
      print('Supabase error: ${e.message}');
      throw Exception('خطا هنگام حذف دسته‌بندی: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('خطای غیرمنتظره هنگام حذف دسته‌بندی: $e');
    }
  }
}
