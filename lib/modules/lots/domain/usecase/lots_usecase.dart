import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/lots/domain/repository/lots_domain_repository.dart';

/// UseCase для получения всех лотов
class GetLotsUseCase {
  final LotDomainRepository repository;

  GetLotsUseCase(this.repository);

  Future<List<LotEntity>> call() async {
    return await repository.getAllLots();
  }
}

/// UseCase для получения лотов конкретного артиста
class GetLotsByArtistUseCase {
  final LotDomainRepository repository;

  GetLotsByArtistUseCase(this.repository);

  Future<List<LotEntity>> call(String artistId) async {
    return await repository.getLotsByArtist(artistId);
  }
}

/// UseCase для получения лота по ID
class GetLotByIdUseCase {
  final LotDomainRepository repository;

  GetLotByIdUseCase(this.repository);

  Future<LotEntity?> call(String id) async {
    return await repository.getLotById(id);
  }
}
