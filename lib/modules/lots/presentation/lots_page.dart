import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/cubit/lot_cubit.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/lots/widgets/lot_card.dart';
import 'package:quick_bid/l10n/app_localizations.dart';

class LotsPage extends StatefulWidget {
  const LotsPage({super.key});

  @override
  State<LotsPage> createState() => _LotsPageState();
}

class _LotsPageState extends State<LotsPage> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные после полной инициализации виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LotsCubit>().fetchLots();
        context.read<ArtistsCubit>().fetchArtists();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Center(
              child: Text(
                loc.lots,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<LotsCubit, AppState<List<LotEntity>>>(
              builder: (context, lotsState) {
                return BlocBuilder<ArtistsCubit, AppState<List<ArtistEntity>>>(
                  builder: (context, artistsState) {
                    // Состояние загрузки
                    if (lotsState.status == StateStatus.loading ||
                        artistsState.status == StateStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Состояние ошибки
                    if (lotsState.status == StateStatus.error) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ошибка: ${lotsState.error}",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<LotsCubit>().fetchLots();
                                context.read<ArtistsCubit>().fetchArtists();
                              },
                              child: const Text("Повторить"),
                            ),
                          ],
                        ),
                      );
                    }

                    // Состояние успеха
                    if (lotsState.status == StateStatus.success) {
                      // Если данных нет
                      if (lotsState.model == null || lotsState.model!.isEmpty) {
                        return Center(
                          child: Text(
                            "${loc.lots} отсутствуют",
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }

                      final List<LotEntity> lots = lotsState.model!;
                      
                      // Создаем мапу артистов для быстрого поиска
                      final Map<String, ArtistEntity> artistsMap = {};
                      if (artistsState.status == StateStatus.success && 
                          artistsState.model != null) {
                        for (var artist in artistsState.model!) {
                          artistsMap[artist.id] = artist;
                        }
                      }

                      // Определяем количество колонок в зависимости от размера экрана
                      final screenWidth = MediaQuery.of(context).size.width;
                      final crossAxisCount = screenWidth >= 768 ? 3 : 2;
                      final photoHeight = screenWidth >= 768 ? 350.0 : (screenWidth >= 600 ? 190.0 : 180.0);
                      
                      return GridView.builder(
                        padding: EdgeInsets.all(12.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 12.h,
                          crossAxisSpacing: 12.w,
                          childAspectRatio: 0.57,
                        ),
                        itemCount: lots.length,
                        itemBuilder: (context, index) {
                          final lot = lots[index];
                          
                          final artist = artistsMap[lot.artistId] ?? ArtistEntity(
  id: lot.artistId,
  name: const LocalizedText(ky: '', ru: '', en: ''),
  photo: '',
  lots: [],
  categoryId: '',
  slug: '',
 description: const LocalizedText(ky: '', ru: '', en: ''),
);

                          return GestureDetector(
                            onTap: () {
                              context.push(
                                '/lot-detail',
                                extra: {'lot': lot},
                              );
                            },
                            child: LotCard(
                              lot: lot,
                              artist: artist,
                              photoHeight: photoHeight,
                              showBuyButton: true,
                            ),
                          );
                        },
                      );
                    }

                    // Начальное состояние (init)
                    return Center(
                      child: Text(
                        "Загрузка...",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
