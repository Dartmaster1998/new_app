import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/helper/image_url_helper.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/payment/widgets/payment_dialog_widget.dart';
import 'package:quick_bid/l10n/app_localizations.dart';

class LotCard extends StatelessWidget {
  final LotEntity lot;
  final ArtistEntity artist;
  final bool showBuyButton;
  final double photoHeight;

  const LotCard({
    super.key,
    required this.lot,
    required this.artist,
    this.showBuyButton = false,
    this.photoHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode;
    final loc = AppLocalizations.of(context);

    String getText(LocalizedText? text) {
      if (text == null) return '';
      return text.getByLang(langCode);
    }
    
    // Для планшета используем увеличенные шрифты
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Container(
      width: 110.w,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фото
          Container(
            margin: EdgeInsets.all(6.w),
            width: double.infinity,
            height: photoHeight.h,
            child: lot.photos.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: Image.network(
                      ImageUrlHelper.getFullImageUrl(lot.photos[0]),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: isDark ? Colors.grey[900] : Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.amber[800],
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark ? Colors.grey[900] : Colors.grey[200],
                          child: Center(
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                        );
                      },
                    ),
                  )
                : const Icon(Icons.image, size: 40),
          ),
          // Название и цена
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getText(lot.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isTablet ? 24.sp : 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${loc?.owner ?? 'Owner'}: ${getText(artist.name)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: isTablet ? 14.sp : 12.sp, color: Colors.grey),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${lot.price} ${loc?.som ?? ''}",
                  style: TextStyle(fontSize: isTablet ? 14.sp : 12.sp, color: Colors.amber[800]),
                ),
                if (showBuyButton)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[800],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        onPressed: () => showBuyModal(
                          context: context,
                          lot: lot,
                          artist: artist,
                          langCode: langCode,
                        ),
                        child: Text(
                          loc?.buy ?? 'Buy',
                          style: TextStyle(fontSize: isTablet ? 14.sp : 11.sp),
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
