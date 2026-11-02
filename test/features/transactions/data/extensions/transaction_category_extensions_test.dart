import 'package:flutter_test/flutter_test.dart';
import 'package:munshi/core/database/app_database.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/features/transactions/data/extensions/transaction_category_extensions.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/domain/value_objects/category_icon_spec.dart';

void main() {
  final tCreatedAt = DateTime(2026);
  const tIcon = CategoryIconSpec(
    codePoint: 0xe25a,
    fontFamily: 'MaterialIcons',
  );
  const tEncodedIcon = '57946,MaterialIcons,';
  const tColorArgb = 0xFF4CAF50;

  // ─────────────────────────────────────────────────────────────
  // TransactionCategoryRowExtensions.toEntity
  // ─────────────────────────────────────────────────────────────

  group('TransactionCategoryRowExtensions.toEntity', () {
    final tRow = TransactionCategoryRow(
      id: 1,
      name: 'Food & Dining',
      icon: tEncodedIcon,
      color: tColorArgb,
      type: TransactionType.expense,
      isDefault: true,
      createdAt: tCreatedAt,
    );

    test('maps all fields correctly', () {
      final entity = tRow.toEntity();

      expect(entity.id, 1);
      expect(entity.name, 'Food & Dining');
      expect(entity.icon, tIcon);
      expect(entity.colorArgb, tColorArgb);
      expect(entity.type, TransactionType.expense);
      expect(entity.isDefault, isTrue);
      expect(entity.createdAt, tCreatedAt);
    });

    test('reflects non-default category correctly', () {
      final row = TransactionCategoryRow(
        id: 10,
        name: 'Shopping',
        icon: tEncodedIcon,
        color: tColorArgb,
        type: TransactionType.expense,
        isDefault: false,
        createdAt: tCreatedAt,
      );

      expect(row.toEntity().isDefault, isFalse);
    });

    test('reflects income type correctly', () {
      final row = TransactionCategoryRow(
        id: 5,
        name: 'Salary',
        icon: tEncodedIcon,
        color: tColorArgb,
        type: TransactionType.income,
        isDefault: false,
        createdAt: tCreatedAt,
      );

      expect(row.toEntity().type, TransactionType.income);
    });
  });

  // ─────────────────────────────────────────────────────────────
  // TransactionCategoryExtension.toRow
  // ─────────────────────────────────────────────────────────────

  group('TransactionCategoryExtension.toRow', () {
    final tEntity = TransactionCategory(
      id: 3,
      name: 'Transport',
      icon: tIcon,
      colorArgb: tColorArgb,
      type: TransactionType.expense,
      isDefault: false,
      createdAt: tCreatedAt,
    );

    test('maps all fields correctly', () {
      final row = tEntity.toRow();

      expect(row.id, 3);
      expect(row.name, 'Transport');
      expect(row.icon, tEncodedIcon);
      expect(row.color, tColorArgb);
      expect(row.type, TransactionType.expense);
      expect(row.isDefault, isFalse);
      expect(row.createdAt, tCreatedAt);
    });

    test('round-trip: toRow().toEntity() produces an equal entity', () {
      final roundTripped = tEntity.toRow().toEntity();
      expect(roundTripped, equals(tEntity));
    });
  });
}
