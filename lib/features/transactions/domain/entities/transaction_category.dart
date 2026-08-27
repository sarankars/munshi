import 'package:equatable/equatable.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/features/transactions/domain/value_objects/category_icon_spec.dart';

/// Represents a transaction category.
///
/// Contains category metadata like name, icon, color, and type.
class TransactionCategory extends Equatable {
  /// Creates a new [TransactionCategory] instance.
  const TransactionCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorArgb,
    required this.type,
    required this.isDefault,
    required this.createdAt,
  });

  /// The unique identifier for this category.
  final int id;

  /// The display name of this category (e.g. "Food", "Transport").
  final String name;

  /// UI-independent metadata for the icon representing this category.
  final CategoryIconSpec icon;

  /// The colour used to visually distinguish this category, as a 32-bit ARGB
  /// value.
  final int colorArgb;

  /// Whether this category applies to [TransactionType.income] or
  /// [TransactionType.expense] transactions.
  final TransactionType type;

  /// Whether this category is a built-in default provided by the app.
  ///
  /// Default categories cannot be deleted by the user.
  final bool isDefault;

  /// The date and time when this category was created.
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    name,
    icon,
    colorArgb,
    type,
    isDefault,
    createdAt,
  ];

  /// Returns a copy of this category with the given fields replaced.
  ///
  /// Omitted fields retain their current values.
  TransactionCategory copyWith({
    int? id,
    String? name,
    CategoryIconSpec? icon,
    int? colorArgb,
    TransactionType? type,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorArgb: colorArgb ?? this.colorArgb,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
