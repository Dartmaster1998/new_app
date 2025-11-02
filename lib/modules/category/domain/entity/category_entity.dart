import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';

class CategoryEntity {
  final String id;
  final LocalizedText name;
  final List<String> lotIds;          // Список ID лотов
  final List<ArtistEntity> artists;   // Список артистов в категории

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.lotIds,
    required this.artists,
  });
}