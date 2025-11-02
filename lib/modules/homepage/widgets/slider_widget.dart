import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../artists/domain/entity/artists_entity.dart';

class BannerSlider extends StatelessWidget {
  final List<String> banners;
  final bool isDark;
  final int currentSlide;
  final List<ArtistEntity> bannerArtists; // артисты для баннеров
  final ValueChanged<int>? onPageChanged;

  const BannerSlider({
    super.key,
    required this.banners,
    required this.isDark,
    required this.currentSlide,
    required this.bannerArtists,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 180.h,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 7),
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              if (onPageChanged != null) onPageChanged!(index);
            },
          ),
          itemBuilder: (context, index, _) {
            return GestureDetector(
              onTap: () {
                if (bannerArtists.isNotEmpty && index < bannerArtists.length) {
                  final artist = bannerArtists[index];
                  context.push('/artist-detail', extra: artist);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(
                    banners[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 50),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
