import 'package:equatable/equatable.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/features/transactions/domain/value_objects/category_icon_spec.dart';

/// UI- and persistence-independent values used to create a category.
class TransactionCategoryInput extends Equatable {
  /// Creates a category input.
  const TransactionCategoryInput({
    required this.name,
    required this.icon,
    required this.colorArgb,
    required this.type,
    this.isDefault = false,
  });

  /// The category's display name.
  final String name;

  /// Metadata identifying the category's display icon.
  final CategoryIconSpec icon;

  /// The category color encoded as a 32-bit ARGB value.
  final int colorArgb;

  /// Whether this category represents income or an expense.
  final TransactionType type;

  /// Whether this category is provided by the application.
  final bool isDefault;

  @override
  List<Object?> get props => [name, icon, colorArgb, type, isDefault];
}
