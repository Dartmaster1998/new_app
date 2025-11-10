import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArtistDescriptionSection extends StatelessWidget {
  final String description;
  final bool isTablet;
  final bool isDark;

  const ArtistDescriptionSection({
    super.key,
    required this.description,
    required this.isTablet,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (description.trim().isEmpty) return const SizedBox.shrink();

    return MarkdownBody(
      data: description,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontSize: isTablet ? 18.sp : 14.sp,
          height: 1.5,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
        strong: TextStyle(
          fontSize: isTablet ? 18.sp : 14.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

