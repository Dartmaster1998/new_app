import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/lots/domain/usecase/lots_usecase.dart';

class LotsCubit extends Cubit<AppState<List<LotEntity>>> {
  final GetLotsUseCase getLotsUseCase;
  final GetLotByIdUseCase getLotByIdUseCase; // если нужно по id
  final GetLotsByArtistUseCase getLotsByArtistUseCase; // если нужно фильтровать по артисту

  LotsCubit({
    required this.getLotsUseCase,
    required this.getLotByIdUseCase,
    required this.getLotsByArtistUseCase,
  }) : super(AppState.init());

  /// Получение всех лотов
  Future<void> fetchLots() async {
    emit(AppState.loading());
    try {
      final lots = await getLotsUseCase();
      emit(AppState.success(lots));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }

  /// Получение лота по id
  Future<void> fetchLotById(String id) async {
    emit(AppState.loading());
    try {
      final lot = await getLotByIdUseCase(id);
      if (lot != null) {
        emit(AppState.success([lot])); // оборачиваем в список
      } else {
        emit(AppState.error(error: 'Лот не найден'));
      }
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }

  /// Получение лотов конкретного артиста
  Future<void> fetchLotsByArtist(String artistId) async {
    emit(AppState.loading());
    try {
      final lots = await getLotsByArtistUseCase(artistId);
      emit(AppState.success(lots));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }
}
