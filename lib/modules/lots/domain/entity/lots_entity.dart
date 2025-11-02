import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';

/// Сущность лота
class LotEntity {
  final String id;
  final String artistId;
  final LocalizedText name;
  final LocalizedText description; // nullable
  final double price;
  final List<String> photo;

  const LotEntity({
    required this.id,
    required this.artistId,
    required this.name,
    required  this.description,
    required this.price,
    required this.photo,
  });
}