import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/category/domain/usecase/category_usecase.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

class CategoryCubit extends Cubit<AppState<List<CategoryEntity>>> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetCategoryByIdUseCase getCategoryByIdUseCase;
  final GetLotsByCategoryUseCase getLotsByCategoryUseCase;
  final GetArtistIdsByCategoryUseCase getArtistIdsByCategoryUseCase;

  CategoryCubit({
    required this.getCategoriesUseCase,
    required this.getCategoryByIdUseCase,
    required this.getLotsByCategoryUseCase,
    required this.getArtistIdsByCategoryUseCase,
  }) : super(AppState.init());

  /// Загрузка всех категорий
  Future<void> fetchCategories() async {
    emit(AppState.loading());
    try {
      final categories = await getCategoriesUseCase();
      emit(AppState.success(categories));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }

  /// Загрузка категории по ID
  Future<void> fetchCategoryById(String id) async {
    emit(AppState.loading());
    try {
      final category = await getCategoryByIdUseCase(id);
      if (category != null) {
        emit(AppState.success([category])); // оборачиваем в список
      } else {
        emit(AppState.error(error: 'Категория не найдена'));
      }
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }

  /// Загрузка лотов категории
  Future<void> fetchLotsByCategory(String categoryId) async {
    emit(AppState.loading());
    try {
      final lots = await getLotsByCategoryUseCase(categoryId);
      // Если нужно хранить лоты отдельно, можно создать отдельный Cubit для лотов
      emit(AppState.success(lots.map((lot) => CategoryEntity(
        id: categoryId,
        name: LocalizedText(ky: '', ru: '', en: ''), // пустое имя для примера
        lotIds: lots.map((e) => e.id).toList(),
        artists: [],
      )).toList()));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }

  /// Загрузка ID артистов категории
  Future<void> fetchArtistIdsByCategory(String categoryId) async {
    emit(AppState.loading());
    try {
      final artistIds = await getArtistIdsByCategoryUseCase(categoryId);
      // Обработка данных аналогично
      emit(AppState.success([
        CategoryEntity(
          id: categoryId,
          name: LocalizedText(ky: '', ru: '', en: ''),
          lotIds: [],
          artists: [],
        )
      ]));
    } catch (e) {
      emit(AppState.error(error: e.toString()));
    }
  }
}
