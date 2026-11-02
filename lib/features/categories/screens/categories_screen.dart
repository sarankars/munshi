import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/categories/providers/category_provider.dart';
import 'package:munshi/features/categories/widgets/add_edit_category_dialog.dart';
import 'package:munshi/features/categories/widgets/category_list_tile.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/widgets/cupertino_toast.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  TransactionType _selectedType = TransactionType.expense;

  Future<void> _showAddCategoryDialog(TransactionType type) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddEditCategoryDialog(type: type),
    );
    if (mounted && (result ?? false)) {
      showCupertinoToast(context, 'Category added successfully');
    }
  }

  Future<void> _showEditCategoryDialog(
    TransactionCategory category,
    TransactionType type,
  ) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          AddEditCategoryDialog(type: type, category: category),
    );
    if (mounted && (result ?? false)) {
      showCupertinoToast(context, 'Category updated successfully');
    }
  }

  Future<void> _deleteCategory(int categoryId, String categoryName) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "$categoryName"? This action cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (mounted && (confirmed ?? false)) {
      try {
        await context.read<CategoryProvider>().deleteCategory(categoryId);
        if (mounted) {
          showCupertinoToast(context, 'Category deleted successfully');
        }
      } catch (e) {
        if (mounted) {
          showCupertinoToast(
            context,
            'Error deleting category: $e',
            isError: true,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return CupertinoPageScaffold(
      backgroundColor: colorScheme.surface,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
        border: null,
        middle: Text(
          'Categories',
          style: context.textTheme.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showAddCategoryDialog(_selectedType),
          child: Icon(
            Iconsax.add_outline,
            color: colorScheme.primary,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<TransactionType>(
                  groupValue: _selectedType,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  thumbColor: colorScheme.surface,
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                    }
                  },
                  children: {
                    TransactionType.expense: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.minus_cirlce_outline,
                            size: 18,
                            color: _selectedType == TransactionType.expense
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Expense',
                            style: context.textTheme.bodyMedium.copyWith(
                              fontWeight:
                                  _selectedType == TransactionType.expense
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _selectedType == TransactionType.expense
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TransactionType.income: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.add_circle_outline,
                            size: 18,
                            color: _selectedType == TransactionType.income
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Income',
                            style: context.textTheme.bodyMedium.copyWith(
                              fontWeight:
                                  _selectedType == TransactionType.income
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _selectedType == TransactionType.income
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                ),
              ),
            ),
            Expanded(
              child: _CategoryList(
                type: _selectedType,
                onEdit: (category) =>
                    _showEditCategoryDialog(category, _selectedType),
                onDelete: (category) =>
                    _deleteCategory(category.id, category.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({
    required this.type,
    required this.onEdit,
    required this.onDelete,
  });

  final TransactionType type;
  final ValueChanged<TransactionCategory> onEdit;
  final ValueChanged<TransactionCategory> onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CupertinoActivityIndicator(
              color: colorScheme.primary,
              radius: 14,
            ),
          );
        }

        final categories = type == TransactionType.expense
            ? provider.expenseCategories
            : provider.incomeCategories;

        if (categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: ShapeDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(
                        cornerRadius: 24,
                        cornerSmoothing: 0.6,
                      ),
                    ),
                  ),
                  child: Icon(
                    Iconsax.category_outline,
                    size: 48,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No categories yet',
                  style: context.textTheme.titleLarge.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button above to add your first category',
                  style: context.textTheme.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryListTile(
              category: category,
              onTap: () => onEdit(category),
              onDelete: () => onDelete(category),
            );
          },
        );
      },
    );
  }
}
