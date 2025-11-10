import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/helper/image_url_helper.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/lots/widgets/lot_card.dart';

import 'widgets/artist_description_section.dart';

class ArtistDetailScreen extends StatelessWidget {
  final ArtistEntity artist;

  const ArtistDetailScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode; // 'ru', 'ky', 'en'
    final name = artist.name.getByLang(langCode);
    final description = artist.description.getByLang(langCode);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isTablet ? 22.sp : 18.sp,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                ImageUrlHelper.getFullImageUrl(artist.photo),
                width: double.infinity,
                height: isTablet ? 500.h : 300.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isTablet ? 32.sp : 22.sp, 
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            const Divider(),
            SizedBox(height: 10.h),
            if (description.trim().isNotEmpty) ...[
              ArtistDescriptionSection(
                description: description,
                isTablet: isTablet,
                isDark: isDark,
              ),
              SizedBox(height: 20.h),
              const Divider(),
              SizedBox(height: 10.h),
            ],
            Text(
              {
                'ky': 'Активдүү лоттор',
                'ru': 'Активные лоты',
                'en': 'Active Lots',
              }[langCode] ?? 'Active Lots',
              style: TextStyle(
                fontSize: isTablet ? 24.sp : 18.sp, 
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: artist.lots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: isTablet ? 0.75 : 0.7,
              ),
              itemBuilder: (context, index) {
                final lot = artist.lots[index];
                return GestureDetector(
                  onTap: () {
                    context.push(
                      '/lot-detail',
                      extra: {
                        'lot': lot,
                        'artist': artist,
                      },
                    );
                  },
                  child: LotCard(
                    lot: lot,
                    artist: artist,
                    showBuyButton: true,
                    photoHeight: isTablet ? 370.0 : 120.0,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
