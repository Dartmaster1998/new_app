
import 'package:dio/dio.dart';
import 'package:quick_bid/modules/artists/data/model/artists_model.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/domain/repository/artists_domain_repository.dart';


class ArtistsRepositoryImpl implements ArtistsDomainRepository {
  final Dio _dio;

  static const String _baseUrl =
      'https://auction-backend-mlzq.onrender.com/api/v1';

  ArtistsRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<List<ArtistEntity>> getArtists() async {
    try {
      final response = await _dio.get('$_baseUrl/artists');

      final data = response.data;

      // API может вернуть {"data": [...]} или просто список
      List<dynamic> artistsJson = [];
      if (data is List) {
        artistsJson = data;
      } else if (data is Map<String, dynamic>) {
        if (data['data'] is List) {
          artistsJson = data['data'] as List<dynamic>;
        } else if (data['data'] != null) {
          artistsJson = [data['data']];
        }
      }

      return artistsJson
          .where((json) => json != null && json is Map<String, dynamic>)
          .map((json) => ArtistsModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Ошибка при загрузке артистов: ${e.response?.statusCode} ${e.message}',
      );
    } catch (e) {
      throw Exception('Ошибка при обработке данных артистов: $e');
    }
  }

  @override
  Future<ArtistEntity?> getArtistById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/artists/$id');
      final data = response.data;

      if (response.statusCode == 200 && data != null) {
        Map<String, dynamic>? artistJson;
        if (data is Map<String, dynamic>) {
          artistJson = data;
        } else if (data is Map && data.containsKey('data')) {
          final dataValue = data['data'];
          if (dataValue is Map<String, dynamic>) {
            artistJson = dataValue;
          }
        }

        if (artistJson != null) {
          return ArtistsModel.fromJson(artistJson);
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception(
        'Ошибка при получении артиста по ID: ${e.response?.statusCode} ${e.message}',
      );
    } catch (e) {
      throw Exception('Ошибка при обработке данных артиста: $e');
    }
  }

  @override
  Future<List<ArtistEntity>> getArtistsByCategory(String categoryId) async {
    try {
      final response =
          await _dio.get('$_baseUrl/artists', queryParameters: {'category': categoryId});

      final data = response.data;

      // API может вернуть {"data": [...]} или просто список
      List<dynamic> artistsJson = [];
      if (data is List) {
        artistsJson = data;
      } else if (data is Map<String, dynamic>) {
        if (data['data'] is List) {
          artistsJson = data['data'] as List<dynamic>;
        } else if (data['data'] != null) {
          artistsJson = [data['data']];
        }
      }

      return artistsJson
          .where((json) => json != null && json is Map<String, dynamic>)
          .map((json) => ArtistsModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Ошибка при загрузке артистов по категории: ${e.response?.statusCode} ${e.message}',
      );
    } catch (e) {
      throw Exception('Ошибка при обработке данных артистов по категории: $e');
    }
  }
}