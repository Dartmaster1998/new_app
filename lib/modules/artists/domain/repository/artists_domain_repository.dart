import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';

abstract class ArtistsDomainRepository {

  Future<List<ArtistsEntity>> getArtists();
}
