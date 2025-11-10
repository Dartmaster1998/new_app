import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LotHeaderInfo extends StatelessWidget {
  final String lotName;
  final String ownerLabel;
  final String ownerName;
  final String priceText;
  final bool isTablet;
  final bool isDark;

  const LotHeaderInfo({
    super.key,
    required this.lotName,
    required this.ownerLabel,
    required this.ownerName,
    required this.priceText,
    required this.isTablet,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: isTablet ? 28.sp : 20.sp,
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.white : Colors.black,
    );

    final subtitleStyle = TextStyle(
      fontSize: isTablet ? 20.sp : 16.sp,
      color: Colors.grey,
    );

    final priceStyle = TextStyle(
      fontSize: isTablet ? 26.sp : 18.sp,
      fontWeight: FontWeight.bold,
      color: Colors.amber[800],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lotName,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        SizedBox(height: 8.h),
        Text(
          '$ownerLabel: $ownerName',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: subtitleStyle,
        ),
        SizedBox(height: 8.h),
        Text(
          priceText,
          style: priceStyle,
        ),
      ],
    );
  }
}

