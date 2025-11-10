import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/config/get_it/get_it.dart';
import 'package:quick_bid/core/config/go_router/go_router.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';
import 'package:quick_bid/modules/category/cubit/category_cubit.dart';
import 'package:quick_bid/modules/lots/cubit/lot_cubit.dart';
import 'package:quick_bid/modules/sliders/cubit/sliders_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); 

  runApp(const QuickBid());
}

class QuickBid extends StatelessWidget {
  const QuickBid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 768;
        final designSize = isTablet 
            ? const Size(1024, 1366) // iPad design size
            : const Size(390, 875);  // iPhone design size

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true, 
          builder: (_, __) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AppProvider()),
                BlocProvider<ArtistsCubit>(create: (_) => sl<ArtistsCubit>()),
                BlocProvider<CategoryCubit>(create: (_) => sl<CategoryCubit>()),
                BlocProvider<LotsCubit>(create: (_) => sl<LotsCubit>()),
                BlocProvider<SlidersCubit>(create: (_) => sl<SlidersCubit>()),
              ],
              child: Consumer<AppProvider>(
                builder: (context, app, child) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    themeMode: app.themeMode,
                    theme: ThemeData.light(),
                    darkTheme: ThemeData.dark(),
                    routerConfig: appRouter,
                    locale: app.locale,
                    supportedLocales: const [
                      Locale('ru'),
                      Locale('en'),
                      Locale('ky'),
                    ],
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
