import 'package:quick_bid/modules/sliders/domain/entity/slider_entity.dart';
import 'package:quick_bid/modules/sliders/domain/repository/slider_domain_repository.dart';

/// Use case для получения всех слайдеров
class GetSlidersUseCase {
  final SliderDomainRepository _repository;

  GetSlidersUseCase(this._repository);

  Future<List<SliderEntity>> call() async {
    return await _repository.getAllSliders();
  }
}

