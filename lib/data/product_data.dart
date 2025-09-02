import 'package:baftopia/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {
  Future<ProductModel> addProduct(ProductModel product) async {
    final supabase = Supabase.instance.client;

    final response =
        await supabase
            .from('products')
            .insert({
              'id': product.id,
              'title': product.title,
              'image': product.image,
              'images': product.images,
              'date': product.date.toIso8601String(),
              'time_spent': product.timeSpent,
              'difficulty_level': product.difficultyLevel,
              'description': product.description,
              'category_id': product.category.id,
            })
            .select('*, categories(*)')
            .single();

    print('Supabase response: $response');

    return ProductModel.fromJson(response);
  }

  Future<List<ProductModel>> getProducts() async {
    final supabase = Supabase.instance.client;
    try {
      final List<dynamic> response = await supabase
          .from('products')
          .select('*, categories(*)');

      return response
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<void> removeProduct(String id) async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase
              .from('products')
              .delete()
              .eq('id', id)
              .select()
              .single();

      if (response.isEmpty) {
        throw Exception('No data returned from Supabase.');
      }

      print('Product deleted: $response');
    } on PostgrestException catch (e) {
      print('Supabase error: ${e.message}');
      throw Exception('خطا هنگام حذف محصول: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('خطای غیرمنتظره هنگام حذف محصول: $e');
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final supabase = Supabase.instance.client;

    try {
      final response =
          await supabase
              .from('products')
              .update({
                'title': product.title,
                'image': product.image,
                'images': product.images,
                'date': product.date.toIso8601String(),
                'time_spent': product.timeSpent,
                'difficulty_level': product.difficultyLevel,
                'description': product.description,
                'category_id': product.category.id,
              })
              .eq('id', product.id)
              .select('*, categories(*)')
              .single();

      return ProductModel.fromJson(response);
    } catch (e) {
      print('Error updating product: $e');
      throw Exception('خطا در ویرایش محصول: $e');
    }
  }
}
