import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quick_bid/modules/artists/data/model/artists_model.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/domain/repository/artists_domain_repository.dart';

/// Реализация репозитория артистов через локальный источник данных
class ArtistsRepositoryImpl implements ArtistsDomainRepository {
  final ArtistsLocalDataSource localDataSource;

  ArtistsRepositoryImpl(this.localDataSource);

  @override
  Future<List<ArtistsEntity>> getArtists() async {
    return await localDataSource.loadArtistsFromJson();
  }
}

/// Локальный источник данных для артистов
class ArtistsLocalDataSource {
  /// Загружает список артистов из JSON-файла
  Future<List<ArtistsEntity>> loadArtistsFromJson() async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/artists_data.json',
    );

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((e) => ArtistsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
