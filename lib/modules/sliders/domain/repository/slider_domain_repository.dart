import 'package:quick_bid/modules/sliders/domain/entity/slider_entity.dart';

/// Интерфейс репозитория для слайдеров
abstract class SliderDomainRepository {
  /// Получение всех активных слайдеров
  Future<List<SliderEntity>> getAllSliders();
}

