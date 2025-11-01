import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quick_bid/core/config/get_it/get_it.dart';
import 'package:quick_bid/core/config/go_router/go_router.dart';
import 'package:quick_bid/core/theme/app_provider.dart';
import 'package:quick_bid/l10n/app_localizations.dart';
import 'package:quick_bid/modules/artists/cubit/artists_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init(); 

  runApp(const QuickBid());
}

class QuickBid extends StatelessWidget {
  const QuickBid({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 875),
      builder: (_, __) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            Provider<ArtistsCubit>(create: (_) => sl<ArtistsCubit>()),
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
  }
}
