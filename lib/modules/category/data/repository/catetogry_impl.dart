import 'package:dio/dio.dart';
import 'package:quick_bid/modules/category/data/model/category_modell.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/category/domain/repository/category_domain_repository.dart';
import 'package:quick_bid/modules/lots/data/model/lot_model.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

class CategoryRepositoryImpl implements CategoryDomainRepository {
  final Dio _dio;
  final String _baseUrl;

  CategoryRepositoryImpl({
    required Dio dio,
    String baseUrl = 'https://occasionalistic-tora-atheistically.ngrok-free.dev/api/v1',
  }) : _dio = dio, _baseUrl = baseUrl;

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    try {
      final response = await _dio.get('$_baseUrl/categories');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((json) =>
                CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Error fetching categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('CategoryRepositoryImpl.getAllCategories failed: $e');
    }
  }

  @override
  Future<CategoryEntity?> getCategoryById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/categories/$id');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        return CategoryModel.fromJson(json);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error fetching category by id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('CategoryRepositoryImpl.getCategoryById failed: $e');
    }
  }

  @override
  Future<List<LotEntity>> getLotsByCategory(String categoryId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/categories/$categoryId/lots', 
        // или если API возвращает списки лотов прямо в категории:
        // '$_baseUrl/categories/$categoryId'
      );
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((json) => LotModel.fromJson(json as Map<String, dynamic>))
            .toList()
            .cast<LotEntity>();
      } else {
        throw Exception('Error fetching lots by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('CategoryRepositoryImpl.getLotsByCategory failed: $e');
    }
  }

  @override
  Future<List<String>> getArtistIdsByCategory(String categoryId) async {
    try {
      final response = await _dio.get('$_baseUrl/categories/$categoryId');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        return List<String>.from(json['artists'] as List<dynamic>);
      } else {
        throw Exception('Error fetching artist ids by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('CategoryRepositoryImpl.getArtistIdsByCategory failed: $e');
    }
  }
}
