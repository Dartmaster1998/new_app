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
    return ProfileButtonWidget(
      icon: Icons.language_outlined,
      title: loc.language,
      subtitle: _getLanguageName(app.locale),
      isDark: isDark,
      onTap: () => _showLanguageSelector(context),
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

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: 220.h,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Text(
              loc.chooseLanguage,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Divider(color: isDark ? Colors.white24 : Colors.black12),
            ...languages.entries.map((entry) {
              final isSelected = app.locale == entry.value;
              return ListTile(
                title: Text(
                  entry.key,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                trailing: isSelected ? Icon(Icons.check, color: Colors.amber) : null,
                onTap: () {
                  app.setLocale(entry.value);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}