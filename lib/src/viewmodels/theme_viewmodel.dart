import 'package:flutter/material.dart';

import '../repositories/theme_repository.dart';

class ThemeViewModel extends ChangeNotifier {
  final ThemeRepository _repository;

  ThemeMode _themeMode = ThemeMode.light;

  ThemeViewModel(this._repository);

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final savedTheme = await _repository.getThemeMode();

    _themeMode = savedTheme == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    await _repository.saveThemeMode(
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }
}