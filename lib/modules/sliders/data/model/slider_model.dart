import 'package:quick_bid/modules/sliders/domain/entity/slider_entity.dart';

/// Модель слайдера (для работы с API)
class SliderModel extends SliderEntity {
  const SliderModel({
    required super.id,
    required super.image,
    required super.link,
    required super.order,
    required super.isActive,
  });

  /// Создание из JSON
  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] == true ||
          json['is_active'] == true ||
          json['is_active'] == 1,
    );
  }

  /// Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'link': link,
      'order': order,
      'isActive': isActive,
      'is_active': isActive,
    };
  }
}

