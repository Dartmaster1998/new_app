import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/homepage/widgets/actor_card.dart';
import 'package:quick_bid/modules/homepage/widgets/lot_card.dart';
import 'package:quick_bid/modules/homepage/widgets/choose_catalog.dart';
import 'package:quick_bid/modules/homepage/widgets/header_widget.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
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

  // Здесь укажи, какой артист соответствует каждому слайду
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
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ChooseCatalog(
                activeIndex: _activeCatalogIndex,
                onChanged: (index) {
                  setState(() {
                    _activeCatalogIndex = index;
                  });
                },
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<ArtistsCubit, AppState<List<ArtistsEntity>>>(
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
                    final artists = state.model!;

                    // --- Фильтрация по вкладкам ---
                    List<ArtistsEntity> filteredArtists = [];
                    List<MapEntry<ArtistsEntity, Lot>> filteredLots = [];

                    switch (_activeCatalogIndex) {
                      case 0:
                        filteredArtists = artists;
                        filteredLots =
                            artists
                                .expand(
                                  (artist) => artist.lots.map(
                                    (lot) => MapEntry(artist, lot),
                                  ),
                                )
                                .toList();
                        break;
                      case 1:
                        filteredArtists =
                            artists
                                .where(
                                  (a) =>
                                      (a.category[langCode] ??
                                              a.category['ru'] ??
                                              '')
                                          .toLowerCase() ==
                                      "актер",
                                )
                                .toList();
                        break;
                      case 2:
                        filteredArtists =
                            artists
                                .where(
                                  (a) =>
                                      (a.category[langCode] ??
                                              a.category['ru'] ??
                                              '')
                                          .toLowerCase() ==
                                      "певец",
                                )
                                .toList();
                        break;
                      case 3:
                        filteredLots =
                            artists
                                .expand(
                                  (artist) => artist.lots.map(
                                    (lot) => MapEntry(artist, lot),
                                  ),
                                )
                                .toList();
                        break;
                      case 4:
                        filteredArtists =
                            artists.where((a) {
                              final category =
                                  (a.category[langCode] ??
                                          a.category['ru'] ??
                                          '')
                                      .toLowerCase();
                              return category.isNotEmpty &&
                                  category != "актер" &&
                                  category != "певец";
                            }).toList();
                        break;
                      default:
                        filteredArtists = artists;
                        break;
                    }

                    // --- Фильтр поиска ---
                    if (searchQuery.isNotEmpty) {
                      filteredArtists =
                          filteredArtists
                              .where(
                                (a) =>
                                    (a.name[langCode] ?? a.name['ru'] ?? '')
                                        .toLowerCase()
                                        .contains(searchQuery) ||
                                    a.lots.any(
                                      (lot) => (lot.title[langCode] ??
                                              lot.title['ru'] ??
                                              '')
                                          .toLowerCase()
                                          .contains(searchQuery),
                                    ),
                              )
                              .toList();

                      filteredLots =
                          filteredLots
                              .where(
                                (entry) => (entry.value.title[langCode] ??
                                        entry.value.title['ru'] ??
                                        '')
                                    .toLowerCase()
                                    .contains(searchQuery),
                              )
                              .toList();
                    }

                    // --- Баннер с кликабельными артистами ---
                    List<ArtistsEntity> bannerArtists = [];

                    for (int i = 0; i < banners.length; i++) {
                      final artistId = bannerArtistIds[i];
                      final artist =
                          artists.where((a) => a.id == artistId).toList();
                      if (artist.isNotEmpty) {
                        bannerArtists.add(artist.first);
                      }
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
                                activeDotColor:
                                    isDark ? Colors.white : Colors.black,
                                dotColor: Colors.grey,
                                dotHeight: 6.h,
                                dotWidth: 6.w,
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),

                          // --- Артисты ---
                          if (filteredArtists.isNotEmpty)
                            Text(
                              _activeCatalogIndex == 0
                                  ? "⭐ ${loc.famous}"
                                  : _activeCatalogIndex == 1
                                  ? "⭐ ${loc.actors}"
                                  : _activeCatalogIndex == 2
                                  ? "🎵 ${loc.singers}"
                                  : _activeCatalogIndex == 3
                                  ? loc.lots
                                  : loc.other,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          if (filteredArtists.isNotEmpty)
                            SizedBox(height: 10.h),
                          if (filteredArtists.isNotEmpty)
                            SizedBox(
                              height: 200.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: filteredArtists.length,
                                separatorBuilder:
                                    (_, __) => SizedBox(width: 12.w),
                                itemBuilder: (context, index) {
                                  final artist = filteredArtists[index];
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(
                                        '/artist-detail',
                                        extra: artist,
                                      );
                                    },
                                    child: ActorCard(artist: artist),
                                  );
                                },
                              ),
                            ),
                          if (filteredArtists.isNotEmpty)
                            SizedBox(height: 25.h),

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
                                    separatorBuilder:
                                        (_, __) => SizedBox(width: 12.w),
                                    itemBuilder: (context, index) {
                                      final artist = filteredLots[index].key;
                                      final lot = filteredLots[index].value;
                                      return GestureDetector(
                                        onTap: () {
                                          context.push(
                                            '/lot-detail',
                                            extra: {
                                              'artist': artist,
                                              'lot': lot,
                                            },
                                          );
                                        },
                                        child: LotCard(
                                          lot: lot,
                                          artist: artist,
                                          showBuyButton: false,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          if (filteredLots.isNotEmpty) SizedBox(height: 40.h),
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
