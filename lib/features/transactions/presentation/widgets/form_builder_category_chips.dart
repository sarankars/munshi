import 'package:flutter/cupertino.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/categories/providers/category_provider.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/presentation/extensions/transaction_category_ui_extensions.dart';
import 'package:provider/provider.dart';

class FormBuilderCategoryChips extends StatelessWidget {
  const FormBuilderCategoryChips({
    required this.name,
    required this.type,
    super.key,
    this.initialValue,
    this.selectedValue,
    this.onChanged,
  });

  final String name;
  final TransactionType type;
  final TransactionCategory? initialValue;
  final TransactionCategory? selectedValue;
  final ValueChanged<TransactionCategory?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final activeSelection = selectedValue ?? initialValue;

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categories = type == TransactionType.expense
            ? categoryProvider.expenseCategories
            : categoryProvider.incomeCategories;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = activeSelection?.id == category.id;
            final categoryColor = category.displayColor;

            return CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: () {
                if (onChanged != null) {
                  onChanged!(isSelected ? null : category);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.25),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.displayIcon,
                      size: 18,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : categoryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.name,
                      style: context.textTheme.bodyMedium.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
