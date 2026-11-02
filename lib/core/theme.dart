import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic color palette for Munshi's Cupertino UI in light and dark modes.
class AppColorScheme {
  /// Creates an [AppColorScheme].
  const AppColorScheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  /// Brightness mode of this color scheme.
  final Brightness brightness;

  /// Primary brand color.
  final Color primary;

  /// Contrasting color drawn on [primary].
  final Color onPrimary;

  /// Container tint derived from [primary].
  final Color primaryContainer;

  /// Contrasting color drawn on [primaryContainer].
  final Color onPrimaryContainer;

  /// Secondary accent color.
  final Color secondary;

  /// Contrasting color drawn on [secondary].
  final Color onSecondary;

  /// Container tint derived from [secondary].
  final Color secondaryContainer;

  /// Contrasting color drawn on [secondaryContainer].
  final Color onSecondaryContainer;

  /// Tertiary accent color.
  final Color tertiary;

  /// Contrasting color drawn on [tertiary].
  final Color onTertiary;

  /// Container tint derived from [tertiary].
  final Color tertiaryContainer;

  /// Contrasting color drawn on [tertiaryContainer].
  final Color onTertiaryContainer;

  /// Semantic error color.
  final Color error;

  /// Contrasting color drawn on [error].
  final Color onError;

  /// Container tint derived from [error].
  final Color errorContainer;

  /// Contrasting color drawn on [errorContainer].
  final Color onErrorContainer;

  /// Default background surface color.
  final Color surface;

  /// Primary text and icon color on [surface].
  final Color onSurface;

  /// Muted text and icon color on [surface].
  final Color onSurfaceVariant;

  /// Standard border and divider color.
  final Color outline;

  /// Subtle border and divider color.
  final Color outlineVariant;

  /// Drop shadow color.
  final Color shadow;

  /// Modal backdrop scrim color.
  final Color scrim;

  /// Inverse surface color for high-contrast banners/toasts.
  final Color inverseSurface;

  /// Contrasting text and icon color on [inverseSurface].
  final Color onInverseSurface;

  /// Primary accent color for inverse surfaces.
  final Color inversePrimary;

  /// Lowest-elevation surface container color.
  final Color surfaceContainerLowest;

  /// Low-elevation surface container color.
  final Color surfaceContainerLow;

  /// Default surface container color.
  final Color surfaceContainer;

  /// High-elevation surface container color.
  final Color surfaceContainerHigh;

  /// Highest-elevation surface container color.
  final Color surfaceContainerHighest;

  /// Light mode color palette.
  static const AppColorScheme light = AppColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff24265c),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffe1e0ff),
    onPrimaryContainer: Color(0xff3f4178),
    secondary: Color(0xff5d5c72),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xffe2e0f9),
    onSecondaryContainer: Color(0xff454559),
    tertiary: Color(0xff795369),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffffd8ec),
    onTertiaryContainer: Color(0xff5f3c51),
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff93000a),
    surface: Color(0xfffcf8ff),
    onSurface: Color(0xff1b1b21),
    onSurfaceVariant: Color(0xff46464f),
    outline: Color(0xff777680),
    outlineVariant: Color(0xffc8c5d0),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff303036),
    onInverseSurface: Color(0xfff3eff7),
    inversePrimary: Color(0xffc0c1ff),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff6f2fa),
    surfaceContainer: Color(0xfff0ecf4),
    surfaceContainerHigh: Color(0xffeae7ef),
    surfaceContainerHighest: Color(0xffe4e1e9),
  );

  /// Dark mode color palette.
  static const AppColorScheme dark = AppColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffc0c1ff),
    onPrimary: Color(0xff292a60),
    primaryContainer: Color(0xff3f4178),
    onPrimaryContainer: Color(0xffe1e0ff),
    secondary: Color(0xffc6c4dd),
    onSecondary: Color(0xff2e2f42),
    secondaryContainer: Color(0xff454559),
    onSecondaryContainer: Color(0xffe2e0f9),
    tertiary: Color(0xffe9b9d3),
    onTertiary: Color(0xff46263a),
    tertiaryContainer: Color(0xff5f3c51),
    onTertiaryContainer: Color(0xffffd8ec),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffdad6),
    surface: Color(0xff131318),
    onSurface: Color(0xffe4e1e9),
    onSurfaceVariant: Color(0xffc8c5d0),
    outline: Color(0xff918f9a),
    outlineVariant: Color(0xff46464f),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe4e1e9),
    onInverseSurface: Color(0xff303036),
    inversePrimary: Color(0xff575992),
    surfaceContainerLowest: Color(0xff0e0e13),
    surfaceContainerLow: Color(0xff1b1b21),
    surfaceContainer: Color(0xff1f1f25),
    surfaceContainerHigh: Color(0xff2a292f),
    surfaceContainerHighest: Color(0xff35343a),
  );
}

/// Typography hierarchy for Munshi's Cupertino UI using Manrope.
class AppTextStyles {
  /// Creates an [AppTextStyles] bound to [_colorScheme].
  const AppTextStyles(this._colorScheme);

  final AppColorScheme _colorScheme;

  /// Display small text style (36pt bold).
  TextStyle get displaySmall => GoogleFonts.manrope(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: _colorScheme.onSurface,
  );

  /// Headline small text style (24pt bold).
  TextStyle get headlineSmall => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: _colorScheme.onSurface,
  );

  /// Title large text style (20pt semi-bold).
  TextStyle get titleLarge => GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: _colorScheme.onSurface,
  );

  /// Title medium text style (16pt semi-bold).
  TextStyle get titleMedium => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: _colorScheme.onSurface,
  );

  /// Title small text style (14pt semi-bold).
  TextStyle get titleSmall => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _colorScheme.onSurface,
  );

  /// Body large text style (16pt regular).
  TextStyle get bodyLarge => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _colorScheme.onSurface,
  );

  /// Body medium text style (14pt regular).
  TextStyle get bodyMedium => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: _colorScheme.onSurface,
  );

  /// Body small text style (12pt regular muted).
  TextStyle get bodySmall => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: _colorScheme.onSurfaceVariant,
  );

  /// Label small text style (11pt medium muted).
  TextStyle get labelSmall => GoogleFonts.manrope(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: _colorScheme.onSurfaceVariant,
  );
}

/// Cupertino theme builder for Munshi.
class AppCupertinoTheme {
  const AppCupertinoTheme._();

  /// Returns the [AppColorScheme] matching [brightness].
  static AppColorScheme schemeFor(Brightness brightness) {
    return brightness == Brightness.dark
        ? AppColorScheme.dark
        : AppColorScheme.light;
  }

  /// Builds a [CupertinoThemeData] for [brightness].
  static CupertinoThemeData ofBrightness(Brightness brightness) {
    final scheme = schemeFor(brightness);
    final baseTextStyle = GoogleFonts.manrope(
      color: scheme.onSurface,
      fontSize: 16,
    );

    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: scheme.primary,
      primaryContrastingColor: scheme.onPrimary,
      scaffoldBackgroundColor: scheme.surface,
      barBackgroundColor: scheme.surface.withValues(alpha: 0.88),
      textTheme: CupertinoTextThemeData(
        primaryColor: scheme.primary,
        textStyle: baseTextStyle,
        actionTextStyle: GoogleFonts.manrope(
          color: scheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        tabLabelTextStyle: GoogleFonts.manrope(
          color: scheme.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        navTitleTextStyle: GoogleFonts.manrope(
          color: scheme.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
        navLargeTitleTextStyle: GoogleFonts.manrope(
          color: scheme.onSurface,
          fontSize: 30,
          fontWeight: FontWeight.w800,
        ),
        pickerTextStyle: GoogleFonts.manrope(
          color: scheme.onSurface,
          fontSize: 18,
        ),
        dateTimePickerTextStyle: GoogleFonts.manrope(
          color: scheme.onSurface,
          fontSize: 18,
        ),
      ),
    );
  }
}

/// Convenience accessors on [BuildContext] for Cupertino theme colors and text.
extension AppCupertinoThemeContext on BuildContext {
  /// Returns the current [AppColorScheme] based on [CupertinoTheme] brightness.
  AppColorScheme get colorScheme {
    final brightness =
        CupertinoTheme.maybeBrightnessOf(this) ?? Brightness.light;
    return AppCupertinoTheme.schemeFor(brightness);
  }

  /// Returns the current [AppTextStyles] based on [CupertinoTheme] brightness.
  AppTextStyles get textTheme => AppTextStyles(colorScheme);
}
