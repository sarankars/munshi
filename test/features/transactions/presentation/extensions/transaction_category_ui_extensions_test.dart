import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/domain/value_objects/category_icon_spec.dart';
import 'package:munshi/features/transactions/presentation/extensions/transaction_category_ui_extensions.dart';

void main() {
  const iconSpec = CategoryIconSpec(
    codePoint: 0xee52,
    fontFamily: 'Iconsax',
    fontPackage: 'icons_plus',
  );

  test('converts icon metadata at the presentation boundary', () {
    final iconData = iconSpec.toIconData();

    expect(iconData.codePoint, iconSpec.codePoint);
    expect(iconData.fontFamily, iconSpec.fontFamily);
    expect(iconData.fontPackage, iconSpec.fontPackage);
    expect(iconData.toCategoryIconSpec(), iconSpec);
  });

  test('exposes Flutter display values for a category', () {
    final category = TransactionCategory(
      id: 1,
      name: 'Food',
      icon: iconSpec,
      colorArgb: 0xFF4CAF50,
      type: TransactionType.expense,
      isDefault: true,
      createdAt: DateTime(2026),
    );

    expect(category.displayIcon.toCategoryIconSpec(), iconSpec);
    expect(category.displayColor, const Color(0xFF4CAF50));
  });
}
