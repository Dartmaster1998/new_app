class ArtistsEntity {
  final String id;
  final Map<String, String> name;       // {"ky": "...", "ru": "...", "en": "..."}
  final Map<String, String> category;
  final String photo;
  final Map<String, String> description;
  final List<Lot> lots;

  ArtistsEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.photo,
    required this.description,
    required this.lots,
  });
}

class Lot {
  final String id;
  final Map<String, String> title;
  final Map<String, String> description;
  final double startingPrice;
  final DateTime auctionDate;
  final List<String> photos;   // 1-3 фото

  Lot({
    required this.id,
    required this.title,
    required this.description,
    required this.startingPrice,
    required this.auctionDate,
    required this.photos,
  });
}
