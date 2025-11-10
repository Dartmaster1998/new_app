import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

/// Абстракция для репозитория лотов
abstract class LotDomainRepository {
  /// Получить все лоты
  Future<List<LotEntity>> getAllLots();

  /// Получить лот по ID
  Future<LotEntity> getLotById(String id);

  /// Получить все лоты артиста
  Future<List<LotEntity>> getLotsByArtist(String artistId);
}
