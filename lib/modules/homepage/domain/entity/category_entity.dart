class CategoryEntity {
  final String id;
  final MultilangEntity name;
  final List<String> lots;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.lots,
  });
}
class MultilangEntity {
  final String ky;
  final String ru;
  final String en;

  MultilangEntity({
    required this.ky,
    required this.ru,
    required this.en,
  });

  factory MultilangEntity.fromJson(Map<String, dynamic> json) {
    return MultilangEntity(
      ky: json['ky'] ?? '',
      ru: json['ru'] ?? '',
      en: json['en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'ky': ky,
        'ru': ru,
        'en': en,
      };
}
