import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/modules/sliders/domain/entity/slider_entity.dart';
import 'package:quick_bid/modules/homepage/widgets/slider_widget.dart';

class HomeSliderSection extends StatelessWidget {
  final AppState<List<SliderEntity>> state;
  final bool isDark;
  final int currentSlide;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function(int index) onTap;

  const HomeSliderSection({
    super.key,
    required this.state,
    required this.isDark,
    required this.currentSlide,
    required this.onPageChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (state.status != StateStatus.success ||
        state.model == null ||
        state.model!.isEmpty) {
      return const SizedBox.shrink();
    }

    final sliders = state.model!;

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(currentSlide),
          child: BannerSlider(
            banners: sliders.map((s) => s.image).toList(),
            isDark: isDark,
            currentSlide: currentSlide,
            bannerArtists: const [],
            onPageChanged: onPageChanged,
          ),
        ),
        SizedBox(height: 8.h),
        AnimatedSmoothIndicator(
          activeIndex: currentSlide.clamp(0, sliders.length - 1),
          count: sliders.length,
          effect: ExpandingDotsEffect(
            activeDotColor: isDark ? Colors.white : Colors.black,
            dotColor: Colors.grey,
            dotHeight: 6.h,
            dotWidth: 6.w,
          ),
        ),
        SizedBox(height: 25.h),
      ],
    );
  }
}

