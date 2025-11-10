import '../../../localized_text/localized_text.dart';
class ArtistEntity {
  final String id;
  final LocalizedText name;
  final String photo;
  final String slug;
  final LocalizedText description;
  final String categoryId;
  final List<dynamic> lots; // или List<LotEntity>

  const ArtistEntity({
    required this.id,
    required this.name,
    required this.photo,
    required this.slug,
    required this.description,
    required this.categoryId,
    this.lots = const [],
  });
}
