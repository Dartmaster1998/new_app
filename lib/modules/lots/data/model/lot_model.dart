import 'package:quick_bid/modules/artists/data/model/artists_model.dart';
import 'package:quick_bid/modules/category/data/model/category_modell.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';


class LotModel extends LotEntity {
  const LotModel({
    required super.id,
    required super.artistId,
    required super.name,
    super.description,
    required super.price,
    required super.photos,
    required super.artist,
    required super.categories,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Создание из JSON
  factory LotModel.fromJson(Map<String, dynamic> json) {
    return LotModel(
      id: json['id']?.toString() ?? '',
      artistId: json['artistId']?.toString() ?? '',
      name: json['name'] != null && json['name'] is Map<String, dynamic>
          ? LocalizedText.fromJson(json['name'] as Map<String, dynamic>)
          : const LocalizedText(ky: '', ru: '', en: ''),
      description: json['description'] != null && json['description'] is Map<String, dynamic>
          ? LocalizedText.fromJson(json['description'] as Map<String, dynamic>)
          : null,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList(),
      artist: json['artist'] != null
          ? ArtistsModel.fromJson(json['artist'] as Map<String, dynamic>)
          : ArtistsModel(
           lots: [], 
              id: '',
              name: const LocalizedText(ky: '', ru: '', en: ''),
              photo: '',
              slug: '',
              description: const LocalizedText(ky: '', ru: '', en: ''),
              categoryId: '',
            ),
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artistId': artistId,
      'name': name.toJson(),
      if (description != null) 'description': description!.toJson(),
      'price': price,
      'photos': photos,
      'artist': (artist as ArtistsModel).toJson(),
      'categories': categories.map((e) => (e as CategoryModel).toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
