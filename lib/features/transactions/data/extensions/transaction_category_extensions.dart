import 'package:munshi/core/database/app_database.dart';
import 'package:munshi/features/transactions/data/codecs/category_icon_spec_codec.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';

extension TransactionCategoryRowExtensions on TransactionCategoryRow {
  TransactionCategory toEntity() {
    return TransactionCategory(
      id: id,
      name: name,
      icon: CategoryIconSpecCodec.decode(icon),
      colorArgb: color,
      type: type,
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }
}

extension TransactionCategoryExtension on TransactionCategory {
  TransactionCategoryRow toRow() {
    return TransactionCategoryRow(
      id: id,
      name: name,
      icon: CategoryIconSpecCodec.encode(icon),
      color: colorArgb,
      type: type,
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }
}
