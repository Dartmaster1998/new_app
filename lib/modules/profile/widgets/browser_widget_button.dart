import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_bid/core/helper/texstylehelper.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenBrowserTile extends StatelessWidget {
  final bool isDark;
  final AppLocalizations loc;
  final String url;

  const OpenBrowserTile({
    required this.isDark,
    required this.loc,
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchURL(context, url),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 370.w,
        height: 70.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDark ? Colors.black : Colors.white,
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.black12,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : const Color.fromARGB(255, 240, 241, 242),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/qwer.png",
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.contain,
                  color: Colors.amber,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              loc.open_in_browser,
              style: Texstylehelper.small14blackw500.copyWith(
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Неверная ссылка')),
      );
      return;
    }

    try {
      // Всегда открываем браузер
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // открывает в Chrome/Safari
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    } catch (e) {
      debugPrint("Ошибка при открытии ссылки: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при открытии ссылки')),
      );
    }
  }
}
