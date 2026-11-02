import 'package:equatable/equatable.dart';

/// UI-independent metadata required to render a category icon.
class CategoryIconSpec extends Equatable {
  /// Creates category icon metadata.
  const CategoryIconSpec({
    required this.codePoint,
    this.fontFamily,
    this.fontPackage,
  });

  /// The icon glyph's Unicode code point.
  final int codePoint;

  /// The font family containing the icon glyph.
  final String? fontFamily;

  /// The package providing [fontFamily], when applicable.
  final String? fontPackage;

  @override
  List<Object?> get props => [codePoint, fontFamily, fontPackage];
}
