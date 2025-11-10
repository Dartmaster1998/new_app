import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/category/cubit/category_cubit.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/sliders/cubit/sliders_cubit.dart';
import 'package:quick_bid/modules/sliders/domain/entity/slider_entity.dart';
import 'package:quick_bid/modules/homepage/widgets/header_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/category_filter.dart';
import 'widgets/home_content.dart';
import 'widgets/home_slider_section.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentSlide = 0;
  int _activeCatalogIndex = 0;
  String searchQuery = "";

  Future<void> _handleSliderTap(
    SliderEntity slider,
    List<ArtistEntity> allArtists,
  ) async {
    final rawLink = slider.link.trim();
    if (rawLink.isEmpty) return;

    final linkLower = rawLink.toLowerCase();

    final lotMatch = RegExp(r'artist(\w+)_lot(\w+)').firstMatch(linkLower);
    if (lotMatch != null) {
      final artistId = 'artist${lotMatch.group(1)}';
      final lotId = 'artist${lotMatch.group(1)}_lot${lotMatch.group(2)}';

      LotEntity? targetLot;
      ArtistEntity? targetArtist;

      for (final artist in allArtists) {
        if (artist.id == artistId) {
          targetArtist = artist;
          if (artist.lots.isNotEmpty) {
            targetLot = artist.lots.firstWhere(
              (lot) => lot.id == lotId,
              orElse: () => artist.lots.first,
            );
          }
          break;
        }
      }

      if (targetLot != null && targetArtist != null) {
        if (!mounted) return;
        context.push(
          '/lot-detail',
          extra: {'lot': targetLot, 'artist': targetArtist},
        );
        return;
      }
    }

    final artistMatch = RegExp(r'^artist(\w+)$').firstMatch(linkLower);
    if (artistMatch != null) {
      final artistId = 'artist${artistMatch.group(1)}';
      ArtistEntity? targetArtist;

      try {
        targetArtist = allArtists.firstWhere((artist) => artist.id == artistId);
      } catch (_) {}

      if (targetArtist != null) {
        if (!mounted) return;
        context.push('/artist-detail', extra: targetArtist);
        return;
      }
    }

    final uri = Uri.tryParse(rawLink);
    if (uri != null) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          throw Exception('launchUrl returned false');
        }
        return;
      } catch (_) {}
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Не удалось открыть ссылку',
          style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode(context) ? Colors.black87 : Colors.white,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  @override
  void initState() {
    super.initState();
    // Загружаем данные после полной инициализации виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ArtistsCubit>().fetchArtists();
        context.read<CategoryCubit>().fetchCategories();
        context.read<SlidersCubit>().fetchSliders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isTabletMini = screenWidth >= 600;

    final categoryState = context.watch<CategoryCubit>().state;
    final artistsState = context.watch<ArtistsCubit>().state;
    final slidersState = context.watch<SlidersCubit>().state;

    final categories = categoryState.model ?? const <CategoryEntity>[];
    final allArtists = artistsState.model ?? const <ArtistEntity>[];

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
              langCode: langCode,
            ),
            const Divider(),
            CategoryFilter(
              state: categoryState,
              categories: categories,
              langCode: langCode,
              loc: loc,
              activeIndex: _activeCatalogIndex,
              onCategorySelected: (index) {
                              setState(() {
                                _activeCatalogIndex = index;
                              });
              },
            ),
            SizedBox(height: 20.h),
            HomeSliderSection(
              state: slidersState,
                                    isDark: isDark,
                                    currentSlide: _currentSlide,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentSlide = index;
                                      });
                                    },
              onTap: (index) async {
                final sliders = slidersState.model;
                if (sliders != null &&
                    index >= 0 &&
                    index < sliders.length) {
                  await _handleSliderTap(sliders[index], allArtists);
                }
              },
            ),
            Expanded(
              child: HomeContent(
                categoryState: categoryState,
                artistsState: artistsState,
                categories: categories,
                allArtists: allArtists,
                activeIndex: _activeCatalogIndex,
                searchQuery: searchQuery,
                langCode: langCode,
                isTablet: isTablet,
                isTabletMini: isTabletMini,
                loc: loc,
                onLotTap: (lot, artist) {
                                              context.push(
                                                '/lot-detail',
                                                extra: {
                                                  'lot': lot,
                                                  'artist': artist,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
