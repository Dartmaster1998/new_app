import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/category/data/model/category_modell.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/data/model/lot_model.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

class ArtistsModel extends ArtistEntity {
  const ArtistsModel({
    required super.id,
    required super.name,
    required super.photo,
    required super.lots,
    required super.category,
    required super.slug,
  });

  factory ArtistsModel.fromJson(Map<String, dynamic> json) {
    return ArtistsModel(
      id: json['id'] as String,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      photo: json['photo'] as String,
      lots: (json['lots'] as List<dynamic>? ?? [])
          .map((e) => LotModel.fromJson(e as Map<String, dynamic>))
          .toList()
          .cast<LotEntity>(), // ✅ приводим к List<LotEntity>
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name.toJson(),
      'photo': photo,
      'lots': lots.map((e) => (e as LotModel).toJson()).toList(),
      'category': (category as CategoryModel).toJson(),
      'slug': slug,
    };
  }
}
