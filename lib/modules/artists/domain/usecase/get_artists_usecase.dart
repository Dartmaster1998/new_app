
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/domain/repository/artists_domain_repository.dart';


/// UseCase для получения списка всех артистов
class GetArtistsUseCase {
  final ArtistsDomainRepository repository;

  GetArtistsUseCase(this.repository);

  /// Возвращает список артистов
  Future<List<ArtistEntity>> call() async {
    return await repository.getArtists();
  }
}
/// UseCase для получения артиста по ID
class GetArtistByIdUseCase {
  final ArtistsDomainRepository repository;

  GetArtistByIdUseCase(this.repository);

  Future<ArtistEntity?> call(String id) async {
    return await repository.getArtistById(id);
  }
}

/// UseCase для получения артистов по категории
class GetArtistsByCategoryUseCase {
  final ArtistsDomainRepository repository;

  GetArtistsByCategoryUseCase(this.repository);

  Future<List<ArtistEntity>> call(String categoryId) async {
    return await repository.getArtistsByCategory(categoryId);
  }
}
