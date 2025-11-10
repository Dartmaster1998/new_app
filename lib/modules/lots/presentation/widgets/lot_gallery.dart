import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quick_bid/core/helper/image_url_helper.dart';

class LotGallery extends StatelessWidget {
  final List<String> photos;
  final bool isDark;
  final bool isTablet;
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onThumbnailTap;
  final ValueChanged<String> onImageTap;

  const LotGallery({
    super.key,
    required this.photos,
    required this.isDark,
    required this.isTablet,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
    required this.onThumbnailTap,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final previewHeight = isTablet ? 500.h : 300.h;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: previewHeight,
              child: PageView.builder(
                controller: controller,
                itemCount: photos.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final photoPath = photos[index];
                  final imageUrl = ImageUrlHelper.getFullImageUrl(photoPath);
                  return GestureDetector(
                    onTap: () => onImageTap(photoPath),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: isDark ? Colors.grey[900] : Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                    : null,
                                color: Colors.amber[800],
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (photos.length > 1)
              Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    photos.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentIndex == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (photos.length > 1) ...[
          SizedBox(height: 12.h),
          SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photoPath = photos[index];
                final imageUrl = ImageUrlHelper.getFullImageUrl(photoPath);
                final isSelected = currentIndex == index;
                return GestureDetector(
                  onTap: () => onThumbnailTap(index),
                  child: Container(
                    width: 80.w,
                    margin: EdgeInsets.only(
                      right: index < photos.length - 1 ? 8.w : 0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? Colors.amber[800]!
                            : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: isDark ? Colors.grey[900] : Colors.grey[200],
                                child: Center(
                                  child: SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.amber[800],
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => _buildErrorIcon(),
                          ),
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: isDark ? Colors.grey[900] : Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48.sp, color: Colors.grey),
          SizedBox(height: 8.h),
          Text(
            'Ошибка загрузки',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      color: isDark ? Colors.grey[900] : Colors.grey[200],
      child: Icon(
        Icons.broken_image,
        size: 24.sp,
        color: Colors.grey,
      ),
    );
  }
}

