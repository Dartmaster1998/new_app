
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/category/domain/repository/category_domain_repository.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

/// UseCase для получения всех категорий
class GetCategoriesUseCase {
  final CategoryDomainRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getAllCategories();
  }
}

/// UseCase для получения категории по ID
class GetCategoryByIdUseCase {
  final CategoryDomainRepository repository;

  GetCategoryByIdUseCase(this.repository);

  Future<CategoryEntity?> call(String id) async {
    return await repository.getCategoryById(id);
  }
}

/// UseCase для получения лотов категории
class GetLotsByCategoryUseCase {
  final CategoryDomainRepository repository;

  GetLotsByCategoryUseCase(this.repository);

  Future<List<LotEntity>> call(String categoryId) async {
    return await repository.getLotsByCategory(categoryId);
  }
}

/// UseCase для получения ID артистов категории
class GetArtistIdsByCategoryUseCase {
  final CategoryDomainRepository repository;

  GetArtistIdsByCategoryUseCase(this.repository);

  Future<List<String>> call(String categoryId) async {
    return await repository.getArtistIdsByCategory(categoryId);
  }
}
