import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bid/core/helper/image_url_helper.dart';

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

  Widget _buildImage(String imagePath) {
    // Используем ImageUrlHelper для формирования полного URL
    final fullImageUrl = ImageUrlHelper.getFullImageUrl(imagePath);
    
    // Если это полный URL (начинается с http), используем CachedNetworkImage
    if (fullImageUrl.startsWith('http://') || fullImageUrl.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: fullImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.image, size: 50),
        ),
      );
    } else {
      // Иначе пытаемся загрузить как локальный ресурс
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey.shade300,
          child: const Icon(Icons.image, size: 50),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final sliderHeight = isTablet ? 330.h : 180.h;
    
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: sliderHeight,
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
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: _buildImage(banners[index]),
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
