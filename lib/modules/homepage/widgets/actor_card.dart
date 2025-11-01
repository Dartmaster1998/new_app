import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:go_router/go_router.dart';

class ActorCard extends StatelessWidget {
  final ArtistsEntity artist;
  final double photoHeight; // <--- новый параметр для высоты фото

  const ActorCard({
    super.key,
    required this.artist,
    this.photoHeight = 120, // дефолтное значение 120
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final app = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final lotTextColor = isDark ? const Color.fromARGB(255, 230, 137, 8) : const Color.fromARGB(255, 230, 137, 8);

    final lotCount = artist.lots.length;
    final langCode = app.locale.languageCode;
    final name = _getLangText(artist.name, langCode);
    final category = _getLangText(artist.category, langCode);

    return GestureDetector(
      onTap: () => context.push('/artist-detail', extra: artist),
      child: Container(
        width: 120.w,
        height: photoHeight + 60.h, // высота контейнера зависит от фото
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото артиста
            Container(
              margin: EdgeInsets.all(6.w),
              width: double.infinity,
              height: photoHeight.h, // используем параметр
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  artist.photo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, size: 40),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 18.h,
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 16.h,
                    child: Text(
                      category.isEmpty ? "—" : category,
                      style: TextStyle(fontSize: 12.sp, color: subTextColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 16.h,
                    child: Text(
                      "$lotCount ${loc!.acitvlots??""}.",
                      style: TextStyle(fontSize: 12.sp, color: lotTextColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLangText(Map<String, String> map, String langCode) {
    return map[langCode] ?? map['en'] ?? '';
  }
}
