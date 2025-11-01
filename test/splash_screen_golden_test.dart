import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_bid/modules/splash_screen/splash_screen.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('SplashScreen golden', (WidgetTester tester) async {
    final widget = ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        home: SplashScreen(),
      ),
    );

    await tester.pumpWidgetBuilder(widget);
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'splash_screen');
  });
}
