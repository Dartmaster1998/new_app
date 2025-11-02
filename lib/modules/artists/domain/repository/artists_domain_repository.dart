import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';

abstract class ArtistsDomainRepository {
  /// Получает список всех артистов
  Future<List<ArtistEntity>> getArtists();

  /// Получает артиста по его ID
  Future<ArtistEntity?> getArtistById(String id);

  /// Получает всех артистов по категории (по ID категории)
  Future<List<ArtistEntity>> getArtistsByCategory(String categoryId);

}
