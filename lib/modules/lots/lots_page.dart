import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/homepage/widgets/lot_card.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/lots/lot_detail_screen.dart';

class LotsPage extends StatelessWidget {
  const LotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode; // 'ru', 'ky', 'en'
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
            child: BlocBuilder<ArtistsCubit, AppState<List<ArtistsEntity>>>(
              builder: (context, state) {
                if (state.status == StateStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == StateStatus.error) {
                  return Center(
                    child: Text(
                      "Ошибка: ${state.error}",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }
                if (state.status == StateStatus.success &&
                    state.model!.isNotEmpty) {
                  final artists = state.model!;

                  final allLots = artists
                      .expand(
                        (artist) =>
                            artist.lots.map((lot) => MapEntry(artist, lot)),
                      )
                      .toList();

                  if (allLots.isEmpty) {
                    return Center(
                      child: Text(
                        "${loc.lots} отсутствуют",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.all(12.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: allLots.length,
                    itemBuilder: (context, index) {
                      final artist = allLots[index].key;
                      final lot = allLots[index].value;

                      return GestureDetector(
                        onTap: () {
                          // Тап по карточке → открываем детальный экран
                          context.push(
                            '/lot-detail',
                            extra: {'lot': lot, 'artist': artist},
                          );
                        },
                        child: LotCard(
                          lot: lot,
                          artist: artist,
                          photoHeight: 180,
                          showBuyButton: true,
                        ),
                      );
                    },
                  );
                }

                return Center(
                  child: Text(
                    "${loc.lots} отсутствуют",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
