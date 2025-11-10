import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/profile/widgets/profile_button_widget.dart';

class ProfileLanguageSelector extends StatelessWidget {
  final AppProvider app;
  final bool isDark;
  final AppLocalizations loc;

  const ProfileLanguageSelector({
    required this.app,
    required this.isDark,
    required this.loc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Padding(
      // немного отступов, чтобы не прилипало к краям на телефоне
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16.w),
      child: SizedBox(
        width: isTablet ? 1.sw : double.infinity, // ✅ планшет — во всю ширину
        child: ProfileButtonWidget(
          icon: Icons.language_outlined,
          title: loc.language,
          subtitle: _getLanguageName(app.locale),
          isDark: isDark,
          onTap: () => _showLanguageSelector(context),
        ),
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return "Русский";
      case 'ky':
        return "Кыргызский";
      case 'en':
        return "English";
      default:
        return "Русский";
    }
  }

  void _showLanguageSelector(BuildContext context) {
    final languages = {
      "Русский": const Locale('ru'),
      "Кыргызский": const Locale('ky'),
      "English": const Locale('en'),
    };

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    // 👇 Конфигурация размеров
    final config = {
      'modalHeight': isTablet ? 350.h : 220.h,
      'titleFont': isTablet ? 22.sp : 16.sp,
      'tileFont': isTablet ? 18.sp : 16.sp,
      'iconSize': isTablet ? 26.sp : 22.sp,
      'padding': isTablet ? 16.w : 12.w,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return SizedBox(
          height: config['modalHeight'] as double,
          width: 1.sw, // ✅ чтобы лист занял всю ширину на планшете
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: config['padding'] as double),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    loc.chooseLanguage,
                    style: TextStyle(
                      fontSize: config['titleFont'] as double,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Divider(color: isDark ? Colors.white24 : Colors.black12),
                SizedBox(height: 4.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (_, index) {
                      final entry = languages.entries.elementAt(index);
                      final isSelected = app.locale == entry.value;

                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: isTablet ? 8.h : 4.h,
                        ),
                        title: Text(
                          entry.key,
                          style: TextStyle(
                            fontSize: config['tileFont'] as double,
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.amber,
                                size: config['iconSize'] as double,
                              )
                            : null,
                        onTap: () {
                          app.setLocale(entry.value);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
