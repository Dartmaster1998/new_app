import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';

class ArtistCard extends StatelessWidget {
  final ArtistEntity artist;
  final Lang currentLang; // текущий язык для отображения

  const ArtistCard({
    super.key,
    required this.artist,
    required this.currentLang,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lotCount = artist.lots.length;

    // Получаем текст на текущем языке
    final name = _getLangText(artist.name);
    final category = _getLangText(artist.category.name);

    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final lotTextColor = isDark ? Colors.grey[500] : Colors.grey[600];

    return GestureDetector(
      onTap: () {
        context.push('/artist-detail', extra: artist);
      },
      child: Container(
        width: 250.w,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                bottomLeft: Radius.circular(10.r),
              ),
              child: Image.network(
                artist.photo,
                width: 90.w,
                height: 90.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90.w,
                  height: 90.h,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 40),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: subTextColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "$lotCount активных лотов",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: lotTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- метод для получения текста на текущем языке ---
  String _getLangText(LocalizedText text) {
    switch (currentLang) {
      case Lang.ky:
        return text.getByLang('ky');
      case Lang.ru:
        return text.getByLang('ru');
      case Lang.en:
      default:
        return text.getByLang('en');
    }
  }
}
