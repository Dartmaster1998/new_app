
import 'package:dio/dio.dart';
import 'package:quick_bid/modules/artists/data/model/artists_model.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/domain/repository/artists_domain_repository.dart';


class ArtistsRepositoryImpl implements ArtistsDomainRepository {
  final Dio _dio;

  static const String _baseUrl =
      'https://occasionalistic-tora-atheistically.ngrok-free.dev/api/v1';

  ArtistsRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<List<ArtistEntity>> getArtists() async {
    try {
      final response = await _dio.get('$_baseUrl/artists');

      final data = response.data;

      // API может вернуть {"data": [...]} или просто список
      final List<dynamic> artistsJson =
          data is List ? data : (data['data'] ?? []);

      return artistsJson
          .map((json) => ArtistsModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Ошибка при загрузке артистов: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<ArtistEntity?> getArtistById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/artists/$id');
      final data = response.data;

      if (response.statusCode == 200) {
        final artistJson = data is Map ? data : data['data'];
        return ArtistsModel.fromJson(artistJson);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception(
        'Ошибка при получении артиста по ID: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<List<ArtistEntity>> getArtistsByCategory(String categoryId) async {
    try {
      final response =
          await _dio.get('$_baseUrl/artists', queryParameters: {'category': categoryId});

      final data = response.data;
      final List<dynamic> artistsJson =
          data is List ? data : (data['data'] ?? []);

      return artistsJson
          .map((json) => ArtistsModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        'Ошибка при загрузке артистов по категории: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}