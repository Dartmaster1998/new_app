import 'package:dio/dio.dart';
import 'package:quick_bid/modules/lots/data/model/lot_model.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/lots/domain/repository/lots_domain_repository.dart';

class LotRepositoryImpl implements LotDomainRepository {
  final Dio _dio;
  final String _baseUrl;

  LotRepositoryImpl({
    required Dio dio,
    String baseUrl = "https://auction-backend-mlzq.onrender.com/api/v1",
  }) : _dio = dio, _baseUrl = baseUrl;

  @override
  Future<List<LotEntity>> getAllLots() async {
    try {
      final response = await _dio.get('$_baseUrl/lots');
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
            .toList();
      } else {
        throw Exception('Error fetching lots: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Repository getAllLots failed: $e');
    }
  }

  @override
  Future<LotEntity> getLotById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/lots/$id');
      if (response.statusCode == 200 && response.data != null) {
        Map<String, dynamic>? lotJson;
        final data = response.data;
        
        if (data is Map<String, dynamic>) {
          lotJson = data;
        } else if (data is Map && data.containsKey('data')) {
          final dataValue = data['data'];
          if (dataValue is Map<String, dynamic>) {
            lotJson = dataValue;
          }
        }

        if (lotJson != null) {
          return LotModel.fromJson(lotJson);
        }
        throw Exception('Lot data is null or invalid');
      } else {
        throw Exception('Error fetching lot by id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Repository getLotById failed: $e');
    }
  }

  @override
  Future<List<LotEntity>> getLotsByArtist(String artistId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/lots',
        queryParameters: {'artist_id': artistId},
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
            .toList();
      } else {
        throw Exception('Error fetching lots by artist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Repository getLotsByArtist failed: $e');
    }
  }
}
