import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

/// Модель лота (для работы с API)
class LotModel extends LotEntity {
  const LotModel({
    required super.id,
    required super.artistId,
    required super.name,
    required super.description, // теперь обязательно
    required super.price,
    required super.photo,
  });

  /// Создание из JSON
  factory LotModel.fromJson(Map<String, dynamic> json) {
    return LotModel(
      id: json['id'] as String,
      artistId: json['artist_id'] as String,
      name: LocalizedText.fromJson(json['name'] as Map<String, dynamic>),
      // description теперь обязательный, используем пустой текст, если его нет
      description: json['description'] != null
          ? LocalizedText.fromJson(json['description'] as Map<String, dynamic>)
          : const LocalizedText(ky: '', ru: '', en: ''),
      price: (json['price'] as num).toDouble(),
      photo: List<String>.from(json['photo'] ?? []),
    );
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artist_id': artistId,
      'name': name.toJson(),
      'description': description.toJson(),
      'price': price,
      'photo': photo,
    };
  }
}
