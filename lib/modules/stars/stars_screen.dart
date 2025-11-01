import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/homepage/widgets/actor_card.dart';
import 'package:quick_bid/modules/homepage/widgets/toggle_button.dart';
import 'package:quick_bid/core/theme/app_provider.dart';

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
    final langCode = appProvider.locale.languageCode; // 'ru', 'ky', 'en'
    final isDark = appProvider.themeMode == ThemeMode.dark;

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

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Заголовок + логотип + кнопка поиска
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
                  colorBlendMode:
                      isDark ? BlendMode.modulate : BlendMode.dst,
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
                    _animationController.isDismissed
                        ? Icons.search
                        : Icons.close,
                    size: 26,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: _toggleSearch,
                ),
              ],
            ),
          ),

          /// 🔹 Анимированное поле поиска
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

          /// 🔹 Фильтр категорий с вкладкой "Все"
          BlocBuilder<ArtistsCubit, AppState<List<ArtistsEntity>>>(
            builder: (context, state) {
              if (state.status != StateStatus.success || state.model == null) {
                return const SizedBox.shrink();
              }

              final artists = state.model!;
              final categories = <String>{};

              for (var a in artists) {
                final cat = a.category[langCode] ?? a.category['en'] ?? '';
                if (cat.isNotEmpty) categories.add(cat);
              }

              final allCategories = ['Все', ...categories];

              return SizedBox(
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemCount: allCategories.length,
                  itemBuilder: (context, index) {
                    final cat = allCategories[index];
                    final isActive = cat == selectedCategory ||
                        (selectedCategory == null && cat == 'Все');

                    return ToggleButton(
                      text: cat,
                      width: 110.w,
                      height: 36.h,
                      isActive: isActive,
                      onTap: () {
                        setState(() {
                          selectedCategory = cat == 'Все' ? null : cat;
                        });
                      },
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 10.h),

          /// 🔹 Сетка артистов
          Expanded(
            child: BlocBuilder<ArtistsCubit, AppState<List<ArtistsEntity>>>(
              builder: (context, state) {
                if (state.status == StateStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == StateStatus.error) {
                  return Center(child: Text("Ошибка: ${state.error}"));
                }

                if (state.status == StateStatus.success &&
                    state.model != null &&
                    state.model!.isNotEmpty) {
                  final allArtists = state.model!;

                  // 🔍 Фильтрация по категории и поиску
                  final filteredArtists = allArtists.where((artist) {
                    final categoryMatch = selectedCategory == null
                        ? true
                        : (artist.category[langCode] ??
                                artist.category['en'] ??
                                '') ==
                            selectedCategory;

                    final name = (artist.name[langCode] ??
                            artist.name['en'] ??
                            '')
                        .toLowerCase();
                    final searchMatch = name.contains(searchQuery.toLowerCase());

                    return categoryMatch && searchMatch;
                  }).toList();

                  if (filteredArtists.isEmpty) {
                    return const Center(child: Text("Артисты не найдены"));
                  }

                  return GridView.builder(
                    padding: EdgeInsets.all(12.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: filteredArtists.length,
                    itemBuilder: (context, index) {
                      final artist = filteredArtists[index];
                      return ActorCard(
                        photoHeight: 180,
                        artist: artist,
                      );
                    },
                  );
                }

                return const Center(child: Text("Артисты отсутствуют"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
