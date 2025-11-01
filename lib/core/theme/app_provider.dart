import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // текущая тема
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // текущий язык
  Locale _locale = const Locale('ru');
  Locale get locale => _locale;

  // переключение темы
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // смена языка
  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  // установка темы напрямую
  void setDarkMode(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
