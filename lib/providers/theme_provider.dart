import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the user's preferred theme mode.
enum AppThemeMode {
  /// Follow the system appearance.
  system,

  /// Always use light appearance.
  light,

  /// Always use dark appearance.
  dark,
}

/// Manages the app's [AppThemeMode] and persists it via [SharedPreferences].
class ThemeProvider extends ChangeNotifier {
  /// Creates a [ThemeProvider] and loads the saved theme synchronously.
  ThemeProvider(this.prefs) {
    _loadThemeFromPrefs();
  }
  static const String _themeKey = 'theme_mode';

  AppThemeMode _themeMode = AppThemeMode.light;

  /// The currently selected [AppThemeMode].
  AppThemeMode get themeMode => _themeMode;

  /// Resolves the active [Brightness] given [platformBrightness].
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

  /// A human-readable label for the current theme mode.
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

  /// The [SharedPreferences] instance used to persist the theme.
  final SharedPreferences prefs;

  /// Sets the theme mode from a string label (`'Light'`, `'Dark'`, or
  /// `'Auto'`).
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
    // Matches Flutter's ThemeMode order [system, light, dark]:
    // index 0 = system, 1 = light, 2 = dark.
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
    unawaited(prefs.setInt(_themeKey, _themeMode.index));
  }
}
