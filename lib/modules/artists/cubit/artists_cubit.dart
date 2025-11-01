import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/domain/usecase/get_artists_usecase.dart';
class ArtistsCubit extends Cubit<AppState<List<ArtistsEntity>>> {
  final GetArtistsUseCase getArtistsUseCase;

  ArtistsCubit({required this.getArtistsUseCase})
      : super(AppState.init());

  Future<void> fetchArtists() async {
    emit(AppState.loading());
    try {
      final artists = await getArtistsUseCase.call();
      emit(AppState.success(artists));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }
}
