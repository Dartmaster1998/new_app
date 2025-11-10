import 'package:quick_bid/modules/artists/data/model/artists_model.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';

import '../../domain/entity/category_entity.dart' show CategoryEntity;
import '../../domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.lotIds,
    required super.artists,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] != null && json['name'] is Map<String, dynamic>
          ? LocalizedText.fromJson(json['name'] as Map<String, dynamic>)
          : const LocalizedText(ky: '', ru: '', en: ''),
      lotIds: (json['lots'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => e['id']?.toString() ?? '')
          .where((id) => id.isNotEmpty)
          .toList(),
      artists: (json['artists'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ArtistsModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'lots': lotIds,
      'artists': artists.map((e) => (e as ArtistsModel).toJson()).toList(),
    };
  }
}
