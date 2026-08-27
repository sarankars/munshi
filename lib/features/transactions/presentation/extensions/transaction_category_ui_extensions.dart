import 'package:flutter/widgets.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/domain/value_objects/category_icon_spec.dart';

/// Flutter-specific rendering helpers for a transaction category.
extension TransactionCategoryUiExtensions on TransactionCategory {
  /// The Flutter icon represented by this category's icon metadata.
  IconData get displayIcon => icon.toIconData();

  /// The Flutter color represented by this category's ARGB value.
  Color get displayColor => Color(colorArgb);
}

/// Converts UI-independent icon metadata at the presentation boundary.
extension CategoryIconSpecUiExtensions on CategoryIconSpec {
  /// Creates Flutter [IconData] from this icon specification.
  IconData toIconData() {
    return IconData(
      codePoint,
      fontFamily: fontFamily,
      fontPackage: fontPackage,
    );
  }
}

/// Converts Flutter icon data into its UI-independent representation.
extension IconDataCategoryIconSpecExtensions on IconData {
  /// Creates a [CategoryIconSpec] suitable for domain and persistence layers.
  CategoryIconSpec toCategoryIconSpec() {
    return CategoryIconSpec(
      codePoint: codePoint,
      fontFamily: fontFamily,
      fontPackage: fontPackage,
    );
  }
}
