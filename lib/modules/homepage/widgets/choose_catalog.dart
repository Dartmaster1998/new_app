import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/homepage/widgets/toggle_button.dart';

class ChooseCatalog extends StatelessWidget {
  final int activeIndex;
    
  final Function(int) onChanged;
   ChooseCatalog({
    super.key,
    required this.activeIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
      final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ToggleButton(
            text: loc.all,
            width: 85,
            height: 40,
            isActive: activeIndex == 0,
            onTap: () {
              onChanged(0);
            },
          ),
          SizedBox(width: 8.w),
          ToggleButton(
            text: loc.actors,
            width: 120.w,
            height: 40.h,
            isActive: activeIndex == 1,
            onTap: () {
              onChanged(1);
            },
          ),
          SizedBox(width: 8.w),
          ToggleButton(
            text: loc.singers,
            width: 120.w,
            height: 40.h,
            isActive: activeIndex == 2,
            onTap: () {
              onChanged(2);
            },
          ),
          SizedBox(width: 8.w),
          ToggleButton(
            text: loc.lots,
            width: 120.w,
            height: 40.h,
            isActive: activeIndex == 3,
            onTap: () {
              onChanged(3);
            },
          ),
             SizedBox(width: 8.w),
          ToggleButton(
            text: loc.other,
            width: 120.w,
            height: 40.h,
            isActive: activeIndex == 4,
            onTap: () {
              onChanged(4);
            },
          ),
        ],
      ),
    );
  }
}
