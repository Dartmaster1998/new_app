
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

abstract class CategoryDomainRepository {
  /// Получить все категории
  Future<List<CategoryEntity>> getAllCategories();

  /// Получить категорию по ID
  Future<CategoryEntity?> getCategoryById(String id);

  /// Получить лоты по ID категории
  Future<List<LotEntity>> getLotsByCategory(String categoryId);

  /// Получить артистов в категории
  Future<List<String>> getArtistIdsByCategory(String categoryId);
}
