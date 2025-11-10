import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/modules/sliders/domain/entity/slider_entity.dart';
import 'package:quick_bid/modules/sliders/domain/usecase/get_sliders_usecase.dart';

class SlidersCubit extends Cubit<AppState<List<SliderEntity>>> {
  final GetSlidersUseCase getSlidersUseCase;

  SlidersCubit({
    required this.getSlidersUseCase,
  }) : super(AppState.init());

  /// Получение всех слайдеров
  Future<void> fetchSliders() async {
    emit(AppState.loading());
    try {
      final sliders = await getSlidersUseCase();
      emit(AppState.success(sliders));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }
}

