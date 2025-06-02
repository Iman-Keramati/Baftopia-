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
              'start_date': product.startDate.toIso8601String(),
              'end_date': product.endDate.toIso8601String(),
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
}
