import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/artists/widgets/actor_card.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';

class StarsGrid extends StatelessWidget {
  final AppState<List<ArtistEntity>> state;
  final List<CategoryEntity> categories;
  final String langCode;
  final String? selectedCategory;
  final String searchQuery;
  final bool isDark;
  final double screenWidth;
  final VoidCallback onRetry;

  const StarsGrid({
    super.key,
    required this.state,
    required this.categories,
    required this.langCode,
    required this.selectedCategory,
    required this.searchQuery,
    required this.isDark,
    required this.screenWidth,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black;

    switch (state.status) {
      case StateStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case StateStatus.error:
        return _buildError(textColor);
      case StateStatus.success:
        final artists = state.model ?? const <ArtistEntity>[];
        if (artists.isEmpty) {
          return _buildMessage('Артисты отсутствуют', textColor);
        }
        final filtered = _filterArtists(artists);
        if (filtered.isEmpty) {
          return _buildMessage('Артисты не найдены', textColor);
        }
        return _buildGrid(filtered);
      case StateStatus.init:
        return _buildMessage('Загрузка...', textColor);
    }
  }

  Widget _buildError(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка: ${state.error}',
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Повторить'),
          ),
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

  Widget _buildGrid(List<ArtistEntity> artists) {
    final crossAxisCount = screenWidth >= 768 ? 3 : 2;
    final photoHeight =
        screenWidth >= 768 ? 350.0 : (screenWidth >= 600 ? 190.0 : 180.0);

    return GridView.builder(
      padding: EdgeInsets.all(12.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.7,
      ),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ActorCard(
          photoHeight: photoHeight,
          artist: artist,
          categories: categories,
        );
      },
    );
  }

  List<ArtistEntity> _filterArtists(List<ArtistEntity> artists) {
    final query = searchQuery.trim().toLowerCase();

    return artists.where((artist) {
      final categoryName = _categoryNameFor(artist.categoryId);
      final matchesCategory = selectedCategory == null ||
          (categoryName != null && categoryName == selectedCategory);

      final name = artist.name.getByLang(langCode).toLowerCase();
      final matchesSearch = query.isEmpty || name.contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  String? _categoryNameFor(String categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return category.name.getByLang(langCode);
      }
    }
    return null;
  }
}

