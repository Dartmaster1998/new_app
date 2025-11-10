import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';

class CategoryFilter extends StatelessWidget {
  final AppState<List<CategoryEntity>> state;
  final List<CategoryEntity> categories;
  final String langCode;
  final AppLocalizations loc;
  final int activeIndex;
  final ValueChanged<int> onCategorySelected;

  const CategoryFilter({
    super.key,
    required this.state,
    required this.categories,
    required this.langCode,
    required this.loc,
    required this.activeIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (state.status == StateStatus.loading) {
      return const LinearProgressIndicator();
    }

    if (state.status == StateStatus.error) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Ошибка: ${state.error}',
            style: textTheme.bodyMedium,
          ),
        ),
      );
    }

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
            categories.length + 1,
            (index) {
              final isActive = activeIndex == index;
              final title =
                  index == 0 ? loc.all : categories[index - 1].name.getByLang(langCode);

              return GestureDetector(
                onTap: () => onCategorySelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: isActive ? null : Border.all(color: Colors.black, width: 1),
                  ),
                  child: Text(
                    title,
                    style: textTheme.labelLarge?.copyWith(
                      color: isActive ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

