import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';

/// Сущность лота
class LotEntity {
  final String id;
  final String artistId;
  final LocalizedText name;
  final LocalizedText? description;
  final double price;
  final List<String> photos;
  final ArtistEntity artist;
  final List<CategoryEntity> categories;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LotEntity({
    required this.id,
    required this.artistId,
    required this.name,
    this.description,
    required this.price,
    required this.photos,
    required this.artist,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });
}
