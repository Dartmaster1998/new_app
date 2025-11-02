import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/lots/data/model/lot_model.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/lots/domain/repository/lots_domain_repository.dart';

class LotRepositoryImpl implements LotDomainRepository {
  final Dio _dio;
  final String _baseUrl;

  LotRepositoryImpl({
    required Dio dio,
    String baseUrl = 'https://occasionalistic‑tora‑atheistically.ngrok‑free.dev/api/v1',
  }) : _dio = dio, _baseUrl = baseUrl;

  @override
  Future<List<LotEntity>> getAllLots() async {
    try {
      final response = await _dio.get('$_baseUrl/lots');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return data
             .map((json) => LotModel.fromJson(json as Map<String, dynamic>))
             .toList();
        } else {
          throw Exception('Unexpected data format: expected List');
        }
      } else {
        throw Exception('Error fetching lots: ${response.statusCode}');
      }
    } catch (e) {
      // Можно логировать ошибку или конвертировать в свой тип.
      throw Exception('Repository getAllLots failed: $e');
    }
  }

  @override
  Future<LotEntity> getLotById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/lots/$id');
      if (response.statusCode == 200) {
        final json = response.data as Map<String, dynamic>;
        return LotModel.fromJson(json);
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
        if (data is List) {
          return data
             .map((json) => LotModel.fromJson(json as Map<String, dynamic>))
             .toList();
        } else {
          throw Exception('Unexpected data format for artist lots');
        }
      } else {
        throw Exception('Error fetching lots by artist: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Repository getLotsByArtist failed: $e');
    }
  }
}
