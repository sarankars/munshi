import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/presentation/extensions/transaction_category_ui_extensions.dart';

/// A list tile that displays a single [TransactionCategory] with edit/delete actions.
class CategoryListTile extends StatelessWidget {
  /// Creates a [CategoryListTile] for the given [category].
  const CategoryListTile({
    required this.category,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// The category to display.
  final TransactionCategory category;

  /// Called when the tile is tapped (typically opens the edit dialog).
  final VoidCallback onTap;

  /// Called when the delete action is triggered.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final categoryIcon = category.displayIcon;
    final categoryColor = category.displayColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: ShapeDecoration(
        color: colorScheme.surface,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16,
            cornerSmoothing: 0.6,
          ),
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
        shadows: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.all(16),
        minimumSize: Size.zero,
        onPressed: onTap,
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: ShapeDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 12,
                    cornerSmoothing: 0.6,
                  ),
                  side: BorderSide(
                    color: categoryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
              ),
              child: Icon(categoryIcon, color: categoryColor, size: 24),
            ),
            const SizedBox(width: 16),

            // Category name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.name,
                    style: context.textTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (category.isDefault)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: ShapeDecoration(
                          color: colorScheme.primaryContainer,
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 6,
                              cornerSmoothing: 0.6,
                            ),
                          ),
                        ),
                        child: Text(
                          'Default',
                          style: context.textTheme.labelSmall.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(8),
                  minimumSize: Size.zero,
                  onPressed: onTap,
                  child: Icon(
                    Iconsax.edit_outline,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                if (!category.isDefault)
                  CupertinoButton(
                    padding: const EdgeInsets.all(8),
                    minimumSize: Size.zero,
                    onPressed: onDelete,
                    child: Icon(
                      Iconsax.trash_outline,
                      color: colorScheme.error,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
