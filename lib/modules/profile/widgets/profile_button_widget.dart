import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_bid/core/helper/texstylehelper.dart';

class ProfileButtonWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isDark;

  const ProfileButtonWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : const Color.fromARGB(255, 240, 241, 242),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.amber),
              ),
            ),
            SizedBox(width: 20.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Texstylehelper.small14blackw500.copyWith(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: Texstylehelper.small14blackw500.copyWith(
                    color: isDark ? Colors.white70 : Colors.black,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios,
                color: isDark ? Colors.white70 : Colors.black54),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}
