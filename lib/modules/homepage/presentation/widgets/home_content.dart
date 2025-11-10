import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/widgets/actor_card.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/lots/widgets/lot_card.dart';

class HomeContent extends StatelessWidget {
  final AppState<List<CategoryEntity>> categoryState;
  final AppState<List<ArtistEntity>> artistsState;
  final List<CategoryEntity> categories;
  final List<ArtistEntity> allArtists;
  final int activeIndex;
  final String searchQuery;
  final String langCode;
  final bool isTablet;
  final bool isTabletMini;
  final AppLocalizations loc;
  final void Function(LotEntity lot, ArtistEntity artist) onLotTap;

  const HomeContent({
    super.key,
    required this.categoryState,
    required this.artistsState,
    required this.categories,
    required this.allArtists,
    required this.activeIndex,
    required this.searchQuery,
    required this.langCode,
    required this.isTablet,
    required this.isTabletMini,
    required this.loc,
    required this.onLotTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    if (categoryState.status == StateStatus.loading ||
        artistsState.status == StateStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categoryState.status == StateStatus.error) {
      return _buildMessage('Ошибка категорий: ${categoryState.error}', textColor);
    }

    if (artistsState.status == StateStatus.error) {
      return _buildMessage('Ошибка артистов: ${artistsState.error}', textColor);
    }

    if (categories.isEmpty || allArtists.isEmpty) {
      return _buildMessage('Данные отсутствуют', textColor);
    }

    final filteredArtists = _filterArtists();
    final filteredLots = _collectLots(filteredArtists);

    if (filteredArtists.isEmpty && filteredLots.isEmpty) {
      return _buildMessage('Ничего не найдено', textColor);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filteredArtists.isNotEmpty) ...[
            Text(
              activeIndex == 0
                  ? loc.famous
                  : categories[activeIndex - 1].name.getByLang(langCode),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: isTablet ? 240.h : (isTabletMini ? 220.h : 200.h),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredArtists.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final artist = filteredArtists[index];
                  return ActorCard(
                    artist: artist,
                    photoHeight: isTabletMini ? 140.0 : 120.0,
                    categories: categories,
                  );
                },
              ),
            ),
            SizedBox(height: 25.h),
          ],
          if (filteredLots.isNotEmpty) ...[
            Text(
              loc.lots,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: isTablet ? 240.h : (isTabletMini ? 220.h : 210.h),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredLots.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final entry = filteredLots[index];
                  final artist = entry.key;
                  final lot = entry.value;
                  return GestureDetector(
                    onTap: () => onLotTap(lot, artist),
                    child: LotCard(
                      lot: lot,
                      artist: artist,
                      showBuyButton: false,
                      photoHeight: isTabletMini ? 140.0 : 120.0,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ],
      ),
    );
  }

  Widget _buildMessage(String text, Color textColor) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }

  List<ArtistEntity> _filterArtists() {
    final List<ArtistEntity> categoryFiltered;
    if (activeIndex == 0 || activeIndex > categories.length) {
      categoryFiltered = allArtists;
    } else {
      final selectedCategory = categories[activeIndex - 1];
      categoryFiltered =
          allArtists.where((artist) => artist.categoryId == selectedCategory.id).toList();
    }

    if (searchQuery.isEmpty) {
      return categoryFiltered;
    }

    final query = searchQuery.toLowerCase();

    return categoryFiltered.where((artist) {
      final artistName = artist.name.getByLang(langCode).toLowerCase();
      final nameMatches = artistName.contains(query);
      final lotsMatch = artist.lots
          .whereType<LotEntity>()
          .any((lot) => lot.name.getByLang(langCode).toLowerCase().contains(query));
      return nameMatches || lotsMatch;
    }).toList();
  }

  List<MapEntry<ArtistEntity, LotEntity>> _collectLots(
    List<ArtistEntity> artists,
  ) {
    final List<MapEntry<ArtistEntity, LotEntity>> entries = [];
    final query = searchQuery.toLowerCase();

    for (final artist in artists) {
      for (final lot in artist.lots.whereType<LotEntity>()) {
        final matchesQuery = query.isEmpty ||
            lot.name.getByLang(langCode).toLowerCase().contains(query) ||
            artist.name.getByLang(langCode).toLowerCase().contains(query);
        if (matchesQuery) {
          entries.add(MapEntry(artist, lot));
        }
      }
    }

    return entries;
  }
}

