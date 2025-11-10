import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/category/domain/usecase/category_usecase.dart';
class CategoryCubit extends Cubit<AppState<List<CategoryEntity>>> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetCategoryByIdUseCase getCategoryByIdUseCase;

  CategoryCubit({
    required this.getCategoriesUseCase,
    required this.getCategoryByIdUseCase,
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

  /// Загрузка категории по ID (можно возвращать только одну категорию)
  Future<CategoryEntity?> fetchCategoryById(String id) async {
    try {
      final category = await getCategoryByIdUseCase(id);
      return category;
    } catch (e) {
      emit(AppState.error(error: e.toString()));
      return null;
    }
  }
}
