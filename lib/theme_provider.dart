import 'package:flutter/material.dart';
import 'constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ColorSelection _colorSelected = ColorSelection.pink;

  ThemeMode get themeMode => _themeMode;
  ColorSelection get colorSelected => _colorSelected;

  void changeThemeMode(bool useLightMode) {
    _themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void changeColor(int value) {
    _colorSelected = ColorSelection.values[value];
    notifyListeners();
  }
}
