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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370.w,
      height: 70.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isDark ? Colors.black : Colors.white,
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.white.withOpacity(0.1)
                        : const Color.fromARGB(255, 240, 241, 242),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/moon.png",
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.contain,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Text(
            loc.darkMode,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          const Spacer(),
          Switch.adaptive(value: isDarkMode, onChanged: onChanged),
        ],
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