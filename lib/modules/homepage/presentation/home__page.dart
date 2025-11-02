import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/widgets/actor_card.dart';
import 'package:quick_bid/modules/category/cubit/category_cubit.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/lots/widgets/lot_card.dart';
import 'package:quick_bid/modules/homepage/widgets/header_widget.dart';
import 'package:quick_bid/modules/homepage/widgets/slider_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:go_router/go_router.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentSlide = 0;
  int _activeCatalogIndex = 0;
  String searchQuery = "";

  final List<String> banners = [
    "assets/images/slider1.jpeg",
    "assets/images/slider2.jpeg",
    "assets/images/slider3.jpeg",
    "assets/images/slider4.jpeg",
  ];

  final Map<int, String> bannerArtistIds = {
    0: "artist1",
    1: "artist3",
    2: "artist5",
    3: "artist7",
  };

  @override
  void initState() {
    super.initState();
    context.read<ArtistsCubit>().fetchArtists();
    context.read<CategoryCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            HeaderWidget(
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            const Divider(),
            // --- Вкладки категорий ---
            BlocBuilder<CategoryCubit, AppState<List<CategoryEntity>>>(
              builder: (context, state) {
                if (state.status == StateStatus.loading) {
                  return const LinearProgressIndicator();
                } else if (state.status == StateStatus.error) {
                  return Center(child: Text("Ошибка: ${state.error}", style: TextStyle(color: textColor)));
                } else if (state.status == StateStatus.success && state.model != null) {
                  final categories = state.model!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      children: List.generate(
                        categories.length + 1, // +1 для "Все"
                        (index) {
                          final isActive = _activeCatalogIndex == index;
                          final title = index == 0
                              ? loc.all
                              : categories[index - 1].name.getByLang(langCode);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _activeCatalogIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10.w),
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? (isDark ? Colors.orange : Colors.amber[700])
                                    : (isDark ? Colors.grey[800] : Colors.grey[300]),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: isActive ? Colors.white : textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<CategoryCubit, AppState<List<CategoryEntity>>>(
                builder: (context, state) {
                  if (state.status == StateStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == StateStatus.error) {
                    return Center(
                      child: Text(
                        "Ошибка: ${state.error}",
                        style: TextStyle(color: textColor),
                      ),
                    );
                  } else if (state.status == StateStatus.success &&
                      state.model != null) {
                    final categories = state.model!;

                    // --- Фильтрация артистов и лотов по выбранной вкладке ---
                    List<ArtistEntity> filteredArtists = [];
                    List<MapEntry<ArtistEntity, LotEntity>> filteredLots = [];

                    if (_activeCatalogIndex == 0) {
                      // Все артисты
                      filteredArtists = categories.expand((c) => c.artists).toList();
                    } else {
                      // Выбранная категория
                      final selectedCategory = categories[_activeCatalogIndex - 1];
                      filteredArtists = selectedCategory.artists;
                    }

                    // Все лоты от отфильтрованных артистов
                    filteredLots = filteredArtists
                        .expand((artist) => artist.lots.map((lot) => MapEntry(artist, lot)))
                        .toList();

                    // --- Поиск ---
                    if (searchQuery.isNotEmpty) {
                      filteredArtists = filteredArtists
                          .where((a) =>
                              a.name.getByLang(langCode).toLowerCase().contains(searchQuery) ||
                              a.lots.any((lot) =>
                                  lot.name.getByLang(langCode).toLowerCase().contains(searchQuery)))
                          .toList();

                      filteredLots = filteredLots
                          .where((entry) =>
                              entry.value.name.getByLang(langCode).toLowerCase().contains(searchQuery))
                          .toList();
                    }

                    // --- Баннер с кликабельными артистами ---
                    List<ArtistEntity> bannerArtists = [];
                    for (int i = 0; i < banners.length; i++) {
                      final artistId = bannerArtistIds[i];
                      final artistMatch = filteredArtists.where((a) => a.id == artistId);
                      if (artistMatch.isNotEmpty) bannerArtists.add(artistMatch.first);
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_currentSlide < bannerArtists.length) {
                                context.push(
                                  '/artist-detail',
                                  extra: bannerArtists[_currentSlide],
                                );
                              }
                            },
                            child: BannerSlider(
                              banners: banners,
                              isDark: isDark,
                              currentSlide: _currentSlide,
                              bannerArtists: bannerArtists,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentSlide = index;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: _currentSlide,
                              count: banners.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: isDark ? Colors.white : Colors.black,
                                dotColor: Colors.grey,
                                dotHeight: 6.h,
                                dotWidth: 6.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),

                          // --- Артисты ---
                          if (filteredArtists.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _activeCatalogIndex == 0 ? loc.famous : filteredArtists.first.category.name.getByLang(langCode),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  height: 200.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredArtists.length,
                                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                                    itemBuilder: (context, index) {
                                      final artist = filteredArtists[index];
                                      return ActorCard(
                                        artist: artist,
                                        photoHeight: 120,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 25.h),
                              ],
                            ),

                          // --- Лоты ---
                          if (filteredLots.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.lots,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                SizedBox(
                                  height: 200.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: filteredLots.length,
                                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                                    itemBuilder: (context, index) {
                                      final artist = filteredLots[index].key;
                                      final lot = filteredLots[index].value;
                                      return LotCard(
                                        lot: lot,
                                        artist: artist,
                                        showBuyButton: false,
                                        photoHeight: 120,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 40.h),
                              ],
                            ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
