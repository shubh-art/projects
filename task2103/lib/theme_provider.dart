import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    load();
  }

  void toggleTheme() {
    _themeMode == ThemeMode.light
        ? setTheme(ThemeMode.dark)
        : setTheme(ThemeMode.light);
  }

  Future<void> setTheme(ThemeMode theme) async {
    _themeMode = theme;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final themeString = theme == ThemeMode.light ? 'light' : 'dark';

    await prefs.setString('theme', themeString);

    notifyListeners();
  }

  Future<void> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final themeString = prefs.get('theme');

    if (themeString == 'light') {
      _themeMode = ThemeMode.light;
    } else if (themeString == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }
}
