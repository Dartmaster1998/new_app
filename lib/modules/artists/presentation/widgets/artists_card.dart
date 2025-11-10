import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/helper/image_url_helper.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/category/data/model/category_modell.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';

class ActorCard extends StatelessWidget {
  final ArtistEntity artist;
  final double photoHeight;
  final List<CategoryEntity> categories; // список категорий для поиска по categoryId

  const ActorCard({
    super.key,
    required this.artist,
    this.photoHeight = 120,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final lotTextColor = const Color.fromARGB(255, 230, 137, 8);

    final lotCount = artist.lots.length;
    final name = artist.name.getByLang(langCode);

    // Получаем категорию артиста по categoryId
    final category = categories.firstWhere(
      (c) => c.id == artist.categoryId,
      orElse: () => CategoryModel(
        id: '',
        name: const LocalizedText(ky: '', ru: '', en: ''),
        lotIds: [],
        artists: [],
      ),
    );
    final categoryName = category.name.getByLang(langCode);

    // Для планшета используем увеличенные шрифты
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return GestureDetector(
      onTap: () => context.push('/artist-detail', extra: artist),
      child: Container(
        width: 120.w,
        height: photoHeight + 60.h,
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
            // Фото артиста с индикатором загрузки
            Container(
              margin: EdgeInsets.all(6.w),
              width: double.infinity,
              height: photoHeight.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  ImageUrlHelper.getFullImageUrl(artist.photo),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
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
                        fontSize: isTablet ? 18.sp : 14.sp,
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
                      categoryName.isEmpty ? "—" : categoryName,
                      style: TextStyle(
                        fontSize: isTablet ? 16.sp : 12.sp,
                        color: subTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 16.h,
                    child: Text(
                      "$lotCount ${loc?.acitvlots ?? ""}.",
                      style: TextStyle(
                        fontSize: isTablet ? 16.sp : 12.sp,
                        color: lotTextColor,
                      ),
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
}
