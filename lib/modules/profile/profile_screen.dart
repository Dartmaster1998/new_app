import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/profile/widgets/browser_widget_button.dart';
import 'package:quick_bid/modules/profile/widgets/profile_headar.dart';
import 'package:quick_bid/modules/profile/widgets/profile_language_selector.dart';
import 'package:quick_bid/modules/profile/widgets/public_offer.dart';
import 'package:quick_bid/modules/profile/widgets/theme_switcher.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);
    final isDark = app.themeMode == ThemeMode.dark;
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(isDark: isDark, loc: loc),
              SizedBox(height: 10.h),
              ProfileLanguageSelector(app: app, isDark: isDark, loc: loc),
              SizedBox(height: 10.h),
              ThemeSwitcherTile(app: app, isDark: isDark, loc: loc),
              SizedBox(height: 10.h),
              OpenBrowserTile(
                isDark: isDark,
                loc: loc,
                url: "https://kassir.kg/ru",
              ),
              SizedBox(height: 10.h),
              PublicOfferTile(isDark: isDark, loc: loc),
            ],
          ),
        ),
      ),
    );
  }
}
