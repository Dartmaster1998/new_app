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
    String baseUrl = 'https://auction-backend-mlzq.onrender.com/api/v1',
  }) : _dio = dio, _baseUrl = baseUrl;

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    try {
      final response = await _dio.get('$_baseUrl/categories');
      if (response.statusCode == 200) {
        final data = response.data;
        
        List<dynamic> categoriesJson = [];
        if (data is List) {
          categoriesJson = data;
        } else if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            categoriesJson = data['data'] as List<dynamic>;
          } else if (data['data'] != null) {
            categoriesJson = [data['data']];
          }
        }

        return categoriesJson
            .where((json) => json != null && json is Map<String, dynamic>)
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
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
      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic>? categoryJson;
        final data = response.data;
        
        if (data is Map<String, dynamic>) {
          categoryJson = data;
        } else if (data is Map && data.containsKey('data')) {
          final dataValue = data['data'];
          if (dataValue is Map<String, dynamic>) {
            categoryJson = dataValue;
          }
        }

        if (categoryJson != null) {
          return CategoryModel.fromJson(categoryJson);
        }
        return null;
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
        final data = response.data;
        
        List<dynamic> lotsJson = [];
        if (data is List) {
          lotsJson = data;
        } else if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            lotsJson = data['data'] as List<dynamic>;
          } else if (data['data'] != null) {
            lotsJson = [data['data']];
          }
        }

        return lotsJson
            .where((json) => json != null && json is Map<String, dynamic>)
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
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        Map<String, dynamic>? json;
        
        if (data is Map<String, dynamic>) {
          json = data;
        } else if (data is Map && data.containsKey('data')) {
          final dataValue = data['data'];
          if (dataValue is Map<String, dynamic>) {
            json = dataValue;
          }
        }

        if (json != null && json['artists'] is List) {
          return (json['artists'] as List<dynamic>)
              .map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList();
        }
        return [];
      } else {
        throw Exception('Error fetching artist ids by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('CategoryRepositoryImpl.getArtistIdsByCategory failed: $e');
    }
  }
}
