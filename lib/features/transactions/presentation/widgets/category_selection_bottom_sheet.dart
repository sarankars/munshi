import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/presentation/extensions/transaction_category_ui_extensions.dart';

class CategorySelectionBottomSheet extends StatefulWidget {
  const CategorySelectionBottomSheet({
    required this.categories,
    required this.currentCategoryId,
    required this.transactionType,
    required this.onCategorySelected,
    super.key,
  });

  final List<TransactionCategory> categories;
  final int? currentCategoryId;
  final TransactionType transactionType;
  final void Function(TransactionCategory) onCategorySelected;

  @override
  State<CategorySelectionBottomSheet> createState() =>
      _CategorySelectionBottomSheetState();
}

class _CategorySelectionBottomSheetState
    extends State<CategorySelectionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: ShapeDecoration(
        color: colorScheme.surface,
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.vertical(
            top: SmoothRadius(cornerRadius: 24, cornerSmoothing: 0.6),
          ),
        ),
        shadows: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 4,
              width: 40,
              decoration: ShapeDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 2,
                    cornerSmoothing: 0.6,
                  ),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
              child: Row(
                children: [
                  Icon(
                    Iconsax.category_outline,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Select Category',
                      style: context.textTheme.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Icon(
                      Iconsax.close_circle_outline,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),

            // Categories List
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: widget.categories.length,
                itemBuilder: (context, index) {
                  final category = widget.categories[index];
                  final isSelected = widget.currentCategoryId == category.id;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () {
                        widget.onCategorySelected(category);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: ShapeDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer.withValues(
                                  alpha: 0.5,
                                )
                              : colorScheme.surfaceContainerLow,
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 16,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Category Icon
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: ShapeDecoration(
                                color: category.displayColor.withValues(
                                  alpha: 0.12,
                                ),
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 12,
                                    cornerSmoothing: 0.6,
                                  ),
                                  side: BorderSide(
                                    color: category.displayColor.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                              child: Icon(
                                category.displayIcon,
                                color: category.displayColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Category Name
                            Expanded(
                              child: Text(
                                category.name,
                                style: context.textTheme.bodyLarge.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                            // Selection Indicator
                            if (isSelected)
                              Icon(
                                Iconsax.tick_circle_bold,
                                color: colorScheme.primary,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
