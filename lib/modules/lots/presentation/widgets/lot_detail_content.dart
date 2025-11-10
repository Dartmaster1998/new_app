import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';

import 'lot_buy_button.dart';
import 'lot_description_section.dart';
import 'lot_gallery.dart';
import 'lot_header_info.dart';

class LotDetailContent extends StatelessWidget {
  final LotEntity lot;
  final String lotName;
  final String ownerName;
  final String ownerLabel;
  final String description;
  final String priceText;
  final String buyLabel;
  final bool isDark;
  final bool isTablet;
  final ValueNotifier<int> currentPage;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onThumbnailTap;
  final ValueChanged<String> onImageTap;
  final VoidCallback onBuyTap;

  const LotDetailContent({
    super.key,
    required this.lot,
    required this.lotName,
    required this.ownerName,
    required this.ownerLabel,
    required this.description,
    required this.priceText,
    required this.buyLabel,
    required this.isDark,
    required this.isTablet,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
    required this.onThumbnailTap,
    required this.onImageTap,
    required this.onBuyTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lot.photos.isNotEmpty)
            ValueListenableBuilder<int>(
              valueListenable: currentPage,
              builder: (context, index, _) {
                return LotGallery(
                  photos: lot.photos,
                  isDark: isDark,
                  isTablet: isTablet,
                  controller: pageController,
                  currentIndex: index,
                  onPageChanged: onPageChanged,
                  onThumbnailTap: onThumbnailTap,
                  onImageTap: onImageTap,
                );
              },
            ),
          SizedBox(height: 16.h),
          LotHeaderInfo(
            lotName: lotName,
            ownerLabel: ownerLabel,
            ownerName: ownerName,
            priceText: priceText,
            isTablet: isTablet,
            isDark: isDark,
          ),
          SizedBox(height: 16.h),
          if (description.trim().isNotEmpty)
            LotDescriptionSection(
              description: description,
              isTablet: isTablet,
              isDark: isDark,
            ),
          SizedBox(height: 24.h),
          LotBuyButton(
            label: buyLabel,
            isTablet: isTablet,
            onPressed: onBuyTap,
          ),
        ],
      ),
    );
  }
}

