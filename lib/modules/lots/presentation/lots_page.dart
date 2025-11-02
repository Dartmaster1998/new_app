import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/base/app_state.dart';
import 'package:quick_bid/core/enums/enums.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/artists/domain/entity/artists_entity.dart';
import 'package:quick_bid/modules/category/domain/entity/category_entity.dart';
import 'package:quick_bid/modules/localized_text/localized_text.dart';
import 'package:quick_bid/modules/lots/cubit/lot_cubit.dart';
import 'package:quick_bid/modules/lots/domain/entity/lots_entity.dart';
import 'package:quick_bid/modules/lots/widgets/lot_card.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';

class LotsPage extends StatelessWidget {
  const LotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final langCode = app.locale.languageCode;
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
    if (state.status == StateStatus.success && state.model != null && state.model!.isNotEmpty) {
      final List<LotEntity> lots = state.model!;

      return GridView.builder(
        padding: EdgeInsets.all(12.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.6,
        ),
        itemCount: lots.length,
        itemBuilder: (context, index) {
          final lot = lots[index];
          // Если нужно достать артиста, добавь поле artistId и подтягивай его из модели

          return GestureDetector(
            onTap: () {
              context.push(
                '/lot-detail',
                extra: {'lot': lot},
              );
            },
            child: LotCard(
              lot: lot,
              artist: ArtistEntity(
                id: lot.artistId,
                name: LocalizedText(ky: '', ru: '', en: ''),
                photo: '',
                lots: [],
                category: CategoryEntity(id: '', name: LocalizedText(ky: '', ru: '', en: ''), lotIds: [], artists: []),
                slug: '',
              ), // Временно, если нет артиста
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
)

)

        ],
      ),
    );
  }
}
