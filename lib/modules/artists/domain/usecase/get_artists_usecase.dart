
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/domain/repository/artists_domain_repository.dart';


/// UseCase для получения списка артистов
class GetArtistsUseCase {
  final ArtistsDomainRepository repository;

  GetArtistsUseCase(this.repository);

  /// Возвращает список артистов
  Future<List<ArtistsEntity>> call() async {
    return await repository.getArtists();
  }
}
