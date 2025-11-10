import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

import 'package:quick_bid/core/helper/image_url_helper.dart';

class LotPhotoViewPage extends StatelessWidget {
  final String imageUrl;
  final bool isDark;

  const LotPhotoViewPage({
    super.key,
    required this.imageUrl,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fullUrl = ImageUrlHelper.getFullImageUrl(imageUrl);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(fullUrl),
            backgroundDecoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
            ),
            errorBuilder: (_, __, ___) => _buildErrorState(),
            loadingBuilder: (_, event) {
              if (event == null || event.expectedTotalBytes == null) {
                return _buildLoader();
              }
              return _buildLoader(
                value: event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              );
            },
          ),
          Positioned(
            top: 40.h,
            right: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.w),
                child: const Icon(Icons.close, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader({double? value}) {
    return Center(
      child: CircularProgressIndicator(
        value: value,
        color: Colors.amber[800],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.grey, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            'Ошибка загрузки изображения',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}

