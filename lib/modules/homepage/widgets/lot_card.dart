import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/payment/widgets/payment_dialog_widget.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
class LotCard extends StatelessWidget {
  final Lot lot;
  final ArtistsEntity artist;
  final bool showBuyButton;
  final double photoHeight; // <--- новый параметр

  const LotCard({
    super.key,
    required this.lot,
    required this.artist,
    this.showBuyButton = false,
    this.photoHeight = 120, // дефолтное значение
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode;
    final loc = AppLocalizations.of(context);

    String getText(Map<String, String>? map) {
      if (map == null) return '';
      return map[langCode] ?? map['en'] ?? '';
    }

    return Container(
      width: 110.w,
      height: photoHeight.h + 100.h, // высота контейнера зависит от фото
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фото
          Container(
            margin: EdgeInsets.all(6.w),
            width: double.infinity,
            height: photoHeight.h, // используем параметр
            child: Image.network(
              lot.photos.isNotEmpty ? lot.photos[0] : '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
            ),
          ),
          // Название и цена
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getText(lot.title),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  getText(artist.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${lot.startingPrice ?? 0} ${loc!.som??""}",
                  style: TextStyle(fontSize: 12.sp, color: Colors.amber[800]),
                ),
                if (showBuyButton)
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        onPressed: () =>
                            showBuyModal(context: context, lot: lot, artist: artist, langCode: langCode),
                        child: Text(
                          loc?.buy ?? 'Buy',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
