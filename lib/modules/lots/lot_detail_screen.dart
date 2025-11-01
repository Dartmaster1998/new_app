import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/payment/widgets/payment_dialog_widget.dart';
import 'package:go_router/go_router.dart';

class LotDetailScreen extends StatefulWidget {
  final Lot lot;
  final ArtistsEntity artist;

  const LotDetailScreen({super.key, required this.lot, required this.artist});

  @override
  State<LotDetailScreen> createState() => _LotDetailScreenState();
}

class _LotDetailScreenState extends State<LotDetailScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode;
    final loc = AppLocalizations.of(context)!;

    String getText(Map<String, String>? map) {
      if (map == null) return '';
      return map[langCode] ?? map['en'] ?? '';
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        title: Text(
          getText(widget.lot.title),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Галерея фото
            if (widget.lot.photos.isNotEmpty)
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.lot.photos.length,
                    options: CarouselOptions(
                      height: 300.h,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final imageUrl = widget.lot.photos[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhotoViewPage(
                              imageUrl: imageUrl,
                              isDark: isDark,
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image, size: 60),
                          ),
                        ),
                      );
                    },
                  ),
                  // Индикатор только если фото > 1
                  if (widget.lot.photos.length > 1)
                    Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        "${currentIndex + 1}/${widget.lot.photos.length}",
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 16.h),

            // Название
            Text(
              getText(widget.lot.title),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.h),

            // Владелец
            Text(
              "${loc.owner}: ${getText(widget.artist.name)}",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 8.h),

            // Цена
            Text(
              "${widget.lot.startingPrice} ${loc.som}",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.amber[800],
              ),
            ),
            SizedBox(height: 16.h),

            // Описание
            MarkdownBody(
              data: getText(widget.lot.description),
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 14.sp,
                  height: 1.5,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                strong: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Кнопка купить
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                onPressed: () => showBuyModal(
                  context: context,
                  lot: widget.lot,
                  artist: widget.artist,
                  langCode: langCode,
                ),
                child: Text(loc.buy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoViewPage extends StatelessWidget {
  final String imageUrl;
  final bool isDark;

  const PhotoViewPage({super.key, required this.imageUrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration:
                BoxDecoration(color: isDark ? Colors.black : Colors.white),
          ),
          Positioned(
            top: 40.h,
            right: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
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
}