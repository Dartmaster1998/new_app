import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/data/model/lot_model.dart';

class ArtistsModel extends ArtistEntity {
  const ArtistsModel({
    required super.id,
    required super.name,
    required super.photo,
    required super.description,
    required super.categoryId,
    required super.lots,
    required super.slug,
  });

  factory ArtistsModel.fromJson(Map<String, dynamic> json) {
    return ArtistsModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] != null && json['name'] is Map<String, dynamic>
          ? LocalizedText.fromJson(json['name'] as Map<String, dynamic>)
          : const LocalizedText(ky: '', ru: '', en: ''),
      photo: json['photo']?.toString() ?? '',
      description: json['description'] != null && json['description'] is Map<String, dynamic>
          ? LocalizedText.fromJson(json['description'] as Map<String, dynamic>)
          : const LocalizedText(ky: '', ru: '', en: ''),
      categoryId: json['categoryId']?.toString() ?? '',
      lots: (json['lots'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => LotModel.fromJson(e))
          .toList(),
      slug: json['slug']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'photo': photo,
      'description': description.toJson(),
      'categoryId': categoryId,
      'lots': lots.map((e) => (e as LotModel).toJson()).toList(),
      'slug': slug,
    };
  }
}
