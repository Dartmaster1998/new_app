
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/modules/artists/domain/usecase/get_artists_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/domain/usecase/get_artists_usecase.dart';
import 'package:quick_bid/modules/category/domain/usecase/category_usecase.dart';

class ArtistsCubit extends Cubit<AppState<List<ArtistEntity>>> {
  final GetArtistsUseCase getArtistsUseCase;
  final GetArtistByIdUseCase getArtistByIdUseCase;
  final GetArtistsByCategoryUseCase getArtistsByCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  ArtistsCubit({
    required this.getArtistsUseCase,
    required this.getArtistByIdUseCase,
    required this.getArtistsByCategoryUseCase,
    required this.getCategoriesUseCase,
  }) : super(AppState.init());

  Future<void> fetchArtists() async {
    emit(AppState.loading());
    try {
      final artists = await getArtistsUseCase();
      emit(AppState.success(artists));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }

  Future<void> fetchArtistById(String id) async {
    emit(AppState.loading());
    try {
      final artist = await getArtistByIdUseCase(id);
      if (artist != null) {
        emit(AppState.success([artist]));
      } else {
        emit(AppState.error(error: 'Артист не найден'));
      }
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }

  Future<void> fetchArtistsByCategory(String categoryId) async {
    emit(AppState.loading());
    try {
      final artists = await getArtistsByCategoryUseCase(categoryId);
      emit(AppState.success(artists));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }

  Future<void> fetchCategories() async {
    emit(AppState.loading());
    try {
      final categories = await getCategoriesUseCase();
      // Для категорий можно сделать отдельный Cubit
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }
}
