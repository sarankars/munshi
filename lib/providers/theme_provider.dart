import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the user's preferred theme mode.
enum AppThemeMode {
  /// Always use light appearance.
  light,

  /// Always use dark appearance.
  dark,

  /// Follow the system appearance.
  system,
}

class ThemeProvider extends ChangeNotifier {
  /// Creates a ThemeProvider and loads the theme synchronously from SharedPreferences.
  ThemeProvider(this.prefs) {
    _loadThemeFromPrefs();
  }
  static const String _themeKey = 'theme_mode';

  AppThemeMode _themeMode = AppThemeMode.light;

  AppThemeMode get themeMode => _themeMode;

  /// Resolves the active [Brightness] given the platform's [platformBrightness].
  Brightness resolveBrightness(Brightness platformBrightness) {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        return platformBrightness;
    }
  }

  String get themeModeString {
    switch (_themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'Auto';
    }
  }

  final SharedPreferences prefs;

  void setThemeMode(String themeString) {
    AppThemeMode newThemeMode;
    switch (themeString) {
      case 'Light':
        newThemeMode = AppThemeMode.light;
      case 'Dark':
        newThemeMode = AppThemeMode.dark;
      case 'Auto':
        newThemeMode = AppThemeMode.system;
      default:
        newThemeMode = AppThemeMode.light;
    }

    if (_themeMode != newThemeMode) {
      _themeMode = newThemeMode;
      _saveThemeToPrefs();
      notifyListeners();
    }
  }

  void _loadThemeFromPrefs() {
    // Note: Previously ThemeMode had [system, light, dark] order in Flutter:
    // index 0 = system, 1 = light, 2 = dark, or if saved via index we clamp safely.
    final themeModeIndex = prefs.getInt(_themeKey);
    if (themeModeIndex != null &&
        themeModeIndex >= 0 &&
        themeModeIndex < AppThemeMode.values.length) {
      _themeMode = AppThemeMode.values[themeModeIndex];
    } else {
      _themeMode = AppThemeMode.light;
    }
    notifyListeners();
  }

  void _saveThemeToPrefs() {
    prefs.setInt(_themeKey, _themeMode.index);
  }
}
