import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/category/cubit/category_cubit.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/homepage/widgets/toggle_button.dart';

import 'presentation/widgets/stars_category_filter.dart';
import 'presentation/widgets/stars_grid.dart';
class StarsScreen extends StatefulWidget {
  const StarsScreen({super.key});

  @override
  State<StarsScreen> createState() => _StarsScreenState();
}

class _StarsScreenState extends State<StarsScreen>
    with SingleTickerProviderStateMixin {
  String? selectedCategory;
  String searchQuery = '';
  late final AnimationController _animationController;
  late final Animation<double> _widthAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _widthAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ArtistsCubit>().fetchArtists();
        context.read<CategoryCubit>().fetchCategories(); // загружаем категории
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      if (_animationController.isDismissed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _searchController.clear();
        searchQuery = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final langCode = appProvider.locale.languageCode;
    final isDark = appProvider.themeMode == ThemeMode.dark;
    final categoryState = context.watch<CategoryCubit>().state;
    final artistsState = context.watch<ArtistsCubit>().state;
    final categories = categoryState.model ?? const <CategoryEntity>[];

    final titleText = {
      'ru': 'Знаменитости',
      'ky': 'Билгилүү адамдар',
      'en': 'Famous people',
    }[langCode] ?? 'Artists';

    final searchHint = {
      'ru': 'Поиск артиста...',
      'ky': 'Артисти издөө...',
      'en': 'Search artist...',
    }[langCode] ?? 'Search artist...';

    final allLabel = {
      'ru': 'Все',
      'ky': 'Баары',
      'en': 'All',
    }[langCode] ?? 'All';

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Заголовок + кнопка поиска
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 120.w,
                  height: 50.h,
                  fit: BoxFit.contain,
                  color: isDark ? Colors.white : null,
                  colorBlendMode: isDark ? BlendMode.modulate : BlendMode.dst,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    titleText,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _animationController.isDismissed ? Icons.search : Icons.close,
                    size: 26,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: _toggleSearch,
                ),
              ],
            ),
          ),

          // 🔹 Анимированное поле поиска
          SizeTransition(
            sizeFactor: _widthAnimation,
            axisAlignment: -1.0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) =>
                    setState(() => searchQuery = value.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: searchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          // 🔹 Фильтр категорий
          StarsCategoryFilter(
            state: categoryState,
            categories: categories,
            langCode: langCode,
            allLabel: allLabel,
            selectedCategory: selectedCategory,
            onCategoryChanged: (value) {
              setState(() => selectedCategory = value);
            },
            chipBuilder: (label, isActive, onTap) => ToggleButton(
              text: label,
              width: 110.w,
              height: 36.h,
              isActive: isActive,
              onTap: onTap,
            ),
          ),
          SizedBox(height: 10.h),

          // 🔹 Сетка артистов
          Expanded(
            child: StarsGrid(
              state: artistsState,
              categories: categories,
              langCode: langCode,
              selectedCategory: selectedCategory,
              searchQuery: searchQuery,
              isDark: isDark,
              screenWidth: MediaQuery.of(context).size.width,
              onRetry: () => context.read<ArtistsCubit>().fetchArtists(),
            ),
          ),
        ],
      ),
    );
  }
}
