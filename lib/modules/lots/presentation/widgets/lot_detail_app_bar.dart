import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LotDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isDark;
  final bool isTablet;

  const LotDetailAppBar({
    super.key,
    required this.title,
    required this.isDark,
    required this.isTablet,
  });

  @override
  Size get preferredSize => Size.fromHeight(isTablet ? 70.h : kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: isTablet ? 22.sp : 18.sp,
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

