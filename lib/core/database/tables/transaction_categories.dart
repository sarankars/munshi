import 'package:drift/drift.dart';
import 'package:munshi/core/database/converters/transaction_type_converter.dart';

/// Database table for storing transaction categories.
///
/// Contains category information including name, icon, color, transaction type,
/// and default status tracking.
@DataClassName('TransactionCategoryRow')
class TransactionCategories extends Table {
  /// Unique identifier for the category.
  IntColumn get id => integer().autoIncrement()();

  /// Name of the category.
  TextColumn get name => text()();

  /// Serialized, UI-independent icon metadata associated with the category.
  TextColumn get icon => text()();

  /// The category color encoded as a 32-bit ARGB value.
  IntColumn get color => integer()();

  /// Transaction type (income or expense).
  TextColumn get type => text().map(const TransactionTypeConverter())();

  /// Whether this is a default system category.
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  /// Timestamp when the category was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
