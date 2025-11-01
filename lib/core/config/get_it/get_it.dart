import 'package:get_it/get_it.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/data/repository/artists_repository.dart';
import 'package:quick_bid/modules/artists/domain/repository/artists_domain_repository.dart';
import 'package:quick_bid/modules/artists/domain/usecase/get_artists_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // UseCase
  sl.registerLazySingleton<GetArtistsUseCase>(
    () => GetArtistsUseCase(sl()),
  );

  // Repository
  sl.registerLazySingleton<ArtistsDomainRepository>(
    () => ArtistsRepositoryImpl(ArtistsLocalDataSource()),
  );

  // Cubit
  sl.registerFactory<ArtistsCubit>(
    () => ArtistsCubit(getArtistsUseCase: sl()),
  );
}
