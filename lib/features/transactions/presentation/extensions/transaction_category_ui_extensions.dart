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
    // Dynamic IconData instantiation is intentional here because user-created
    // category icons are persisted in SQLite and decoded at runtime.
    return IconData(
      // ignore: non_const_argument_for_const_parameter, dynamic icon from DB
      codePoint,
      // ignore: non_const_argument_for_const_parameter, dynamic icon from DB
      fontFamily: fontFamily,
      // ignore: non_const_argument_for_const_parameter, dynamic icon from DB
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
