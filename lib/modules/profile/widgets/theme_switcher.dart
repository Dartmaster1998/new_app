import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';

class DarkModeSwitcher extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;
  final bool isDark;
  final AppLocalizations loc;

  const DarkModeSwitcher({
    required this.isDarkMode,
    required this.onChanged,
    required this.isDark,
    required this.loc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    final buttonWidth = isTablet ? 1.sw : double.infinity; // ✅ планшет — вся ширина
    final buttonHeight = isTablet ? 90.h : 70.h;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 0 : 16.w),
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isDark ? Colors.black : Colors.white,
          border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : const Color.fromARGB(255, 240, 241, 242),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/moon.png",
                    width: 22.w,
                    height: 22.h,
                    fit: BoxFit.contain,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Text(
              loc.darkMode,
              style: TextStyle(
                fontSize: isTablet ? 18.sp : 16.sp,
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Transform.scale(
                scale: isTablet ? 1.2 : 1.0,
                child: Switch.adaptive(
                  value: isDarkMode,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSwitcherTile extends StatelessWidget {
  final AppProvider app;
  final bool isDark;
  final AppLocalizations loc;

  const ThemeSwitcherTile({
    required this.app,
    required this.isDark,
    required this.loc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DarkModeSwitcher(
      isDarkMode: isDark,
      onChanged: (value) => app.setDarkMode(value),
      isDark: isDark,
      loc: loc,
    );
  }
}
