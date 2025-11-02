

import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';

import '../../domain/entity/category_entity.dart' show CategoryEntity;

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.lotIds,
    required super.artists,
  });

  /// Создание из JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: LocalizedText.fromJson(json['name']),
      lotIds: List<String>.from(json['lots'] ?? []),
      artists: (json['artists'] as List<dynamic>? ?? [])
          .map((artistJson) => ArtistEntity(
                id: artistJson['id'],
                name: LocalizedText.fromJson(artistJson['name']),
                photo: artistJson['photo'],
                lots: [], // лоты можно загрузить отдельно, если есть только ID
                category: CategoryEntity(
                  id: json['id'],
                  name: LocalizedText.fromJson(json['name']),
                  lotIds: List<String>.from(json['lots'] ?? []),
                  artists: [],
                ),
                slug: artistJson['slug'] ?? '',
              ))
          .toList(),
    );
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'lots': lotIds,
      'artists': artists
          .map((artist) => {
                'id': artist.id,
                'name': artist.name.toJson(),
                'photo': artist.photo,
                'slug': artist.slug,
              })
          .toList(),
    };
  }
}
