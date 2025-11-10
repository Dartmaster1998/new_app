import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';

typedef StarsFilterChipBuilder = Widget Function(
  String label,
  bool isActive,
  VoidCallback onTap,
);

class StarsCategoryFilter extends StatelessWidget {
  final AppState<List<CategoryEntity>> state;
  final List<CategoryEntity> categories;
  final String langCode;
  final String allLabel;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryChanged;
  final StarsFilterChipBuilder chipBuilder;

  const StarsCategoryFilter({
    super.key,
    required this.state,
    required this.categories,
    required this.langCode,
    required this.allLabel,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.chipBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (state.status != StateStatus.success || state.model == null) {
      return const SizedBox.shrink();
    }

    final chips = <String>[allLabel, ..._buildCategoryLabels()];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemCount: chips.length,
        itemBuilder: (context, index) {
          final label = chips[index];
          final isActive = selectedCategory == null
              ? index == 0
              : label == selectedCategory;

          return chipBuilder(
            label,
            isActive,
            () => onCategoryChanged(index == 0 ? null : label),
          );
        },
      ),
    );
  }

  List<String> _buildCategoryLabels() {
    return categories
        .map((category) => category.name.getByLang(langCode))
        .where((label) => label.isNotEmpty)
        .toList();
  }
}

