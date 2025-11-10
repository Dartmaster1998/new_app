import 'package:equatable/equatable.dart';

/// Мультиязычный текст
class LocalizedText extends Equatable {
  final String ky;
  final String ru;
  final String en;

  const LocalizedText({
    required this.ky,
    required this.ru,
    required this.en,
  });

  /// Создание из JSON
  factory LocalizedText.fromJson(Map<String, dynamic> json) => LocalizedText(
        ky: json['ky'] ?? '',
        ru: json['ru'] ?? '',
        en: json['en'] ?? '',
      );

  /// Получение текста по языку
  String getByLang(String langCode) {
    switch (langCode) {
      case 'ky':
        return ky;
      case 'ru':
        return ru;
      case 'en':
      default:
        return en;
    }
  }

  /// В JSON
  Map<String, dynamic> toJson() => {'ky': ky, 'ru': ru, 'en': en};

  @override
  List<Object?> get props => [ky, ru, en];
}
