import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// --- Artists ---
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/data/repository/artists_repository.dart';
import 'package:quick_bid/modules/artists/domain/repository/artists_domain_repository.dart';
import 'package:quick_bid/modules/artists/domain/usecase/get_artists_usecase.dart';

// --- Category ---
import 'package:quick_bid/modules/category/cubit/category_cubit.dart';
import 'package:quick_bid/modules/category/data/repository/catetogry_impl.dart';
import 'package:quick_bid/modules/category/domain/repository/category_domain_repository.dart';
import 'package:quick_bid/modules/category/domain/usecase/category_usecase.dart';

// --- Lots ---
import 'package:quick_bid/modules/lots/cubit/lot_cubit.dart';
import 'package:quick_bid/modules/lots/data/repository/repository_impl.dart';
import 'package:quick_bid/modules/lots/domain/repository/lots_domain_repository.dart';
import 'package:quick_bid/modules/lots/domain/usecase/lots_usecase.dart';

// --- Sliders ---
import 'package:quick_bid/modules/sliders/cubit/sliders_cubit.dart';
import 'package:quick_bid/modules/sliders/data/repository/slider_repository_impl.dart';
import 'package:quick_bid/modules/sliders/domain/repository/slider_domain_repository.dart';
import 'package:quick_bid/modules/sliders/domain/usecase/get_sliders_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // --- Repositories ---
  sl.registerLazySingleton<ArtistsDomainRepository>(
      () => ArtistsRepositoryImpl(dio: sl()));
  sl.registerLazySingleton<CategoryDomainRepository>(
      () => CategoryRepositoryImpl(dio: sl()));
  sl.registerLazySingleton<LotDomainRepository>(
      () => LotRepositoryImpl(dio: sl()));
  sl.registerLazySingleton<SliderDomainRepository>(
      () => SliderRepositoryImpl(dio: sl()));

  // --- Artists UseCases ---
  sl.registerLazySingleton<GetArtistsUseCase>(() => GetArtistsUseCase(sl()));
  sl.registerLazySingleton<GetArtistByIdUseCase>(() => GetArtistByIdUseCase(sl()));
  sl.registerLazySingleton<GetArtistsByCategoryUseCase>(
      () => GetArtistsByCategoryUseCase(sl()));
  sl.registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(sl())); // для списка категорий артистов

  // --- Category UseCases ---
  sl.registerLazySingleton<GetCategoryByIdUseCase>(
      () => GetCategoryByIdUseCase(sl()));
  sl.registerLazySingleton<GetLotsByCategoryUseCase>(
      () => GetLotsByCategoryUseCase(sl()));
  sl.registerLazySingleton<GetArtistIdsByCategoryUseCase>(
      () => GetArtistIdsByCategoryUseCase(sl()));

  // --- Lots UseCases ---
  sl.registerLazySingleton<GetLotsUseCase>(() => GetLotsUseCase(sl()));
  sl.registerLazySingleton<GetLotByIdUseCase>(() => GetLotByIdUseCase(sl()));
  sl.registerLazySingleton<GetLotsByArtistUseCase>(
      () => GetLotsByArtistUseCase(sl()));

  // --- Sliders UseCases ---
  sl.registerLazySingleton<GetSlidersUseCase>(() => GetSlidersUseCase(sl()));

  // --- Cubits ---
  sl.registerFactory<ArtistsCubit>(
    () => ArtistsCubit(
      getArtistsUseCase: sl(),
      getArtistByIdUseCase: sl(),
      getArtistsByCategoryUseCase: sl(),
      getCategoriesUseCase: sl(),
    ),
  );

  sl.registerFactory<CategoryCubit>(
    () => CategoryCubit(
      getCategoriesUseCase: sl(),
      getCategoryByIdUseCase: sl(),
    ),
  );

  sl.registerFactory<LotsCubit>(
    () => LotsCubit(
      getLotsUseCase: sl(),
      getLotByIdUseCase: sl(),
      getLotsByArtistUseCase: sl(),
    ),
  );

  sl.registerFactory<SlidersCubit>(
    () => SlidersCubit(
      getSlidersUseCase: sl(),
    ),
  );
}
