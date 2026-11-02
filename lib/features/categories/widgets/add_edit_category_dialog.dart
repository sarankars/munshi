import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/categories/providers/category_provider.dart';
import 'package:munshi/features/categories/widgets/color_picker_dialog.dart';
import 'package:munshi/features/categories/widgets/icon_picker_dialog.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/domain/value_objects/transaction_category_input.dart';
import 'package:munshi/features/transactions/presentation/extensions/transaction_category_ui_extensions.dart';
import 'package:munshi/widgets/cupertino_toast.dart';
import 'package:provider/provider.dart';

/// A dialog widget for creating a new category or editing an existing one.
class AddEditCategoryDialog extends StatefulWidget {
  /// Creates an [AddEditCategoryDialog] for the given [type].
  ///
  /// Supply [category] to pre-populate fields when editing.
  const AddEditCategoryDialog({required this.type, super.key, this.category});

  /// The transaction type this category belongs to.
  final TransactionType type;

  /// The existing category to edit, or `null` when creating a new one.
  final TransactionCategory? category;

  @override
  State<AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends State<AddEditCategoryDialog> {
  final _nameController = TextEditingController();

  late IconData _selectedIcon;
  late Color _selectedColor;
  bool _isLoading = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _selectedIcon = widget.category!.displayIcon;
      _selectedColor = widget.category!.displayColor;
    } else {
      _selectedIcon = Iconsax.category_outline;
      _selectedColor = CupertinoColors.systemBlue;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectIcon() async {
    final icon = await showCupertinoDialog<IconData>(
      context: context,
      barrierDismissible: true,
      builder: (context) => IconPickerDialog(selectedIcon: _selectedIcon),
    );
    if (icon != null) {
      setState(() {
        _selectedIcon = icon;
      });
    }
  }

  Future<void> _selectColor() async {
    final color = await showCupertinoDialog<Color>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ColorPickerDialog(selectedColor: _selectedColor),
    );
    if (color != null) {
      setState(() {
        _selectedColor = color;
      });
    }
  }

  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Please enter a category name');
      return;
    }

    setState(() {
      _nameError = null;
      _isLoading = true;
    });

    final provider = context.read<CategoryProvider>();

    // Check if name already exists
    final nameExists = await provider.categoryNameExists(
      name,
      widget.type,
      excludeId: widget.category?.id,
    );

    if (nameExists && mounted) {
      setState(() {
        _nameError = 'A category with this name already exists';
        _isLoading = false;
      });
      return;
    }

    try {
      if (widget.category != null) {
        // Update existing category
        final updatedCategory = widget.category!.copyWith(
          name: name,
          icon: _selectedIcon.toCategoryIconSpec(),
          colorArgb: _selectedColor.toARGB32(),
        );
        await provider.updateCategory(updatedCategory);
      } else {
        // Add new category
        final newCategory = TransactionCategoryInput(
          name: name,
          icon: _selectedIcon.toCategoryIconSpec(),
          colorArgb: _selectedColor.toARGB32(),
          type: widget.type,
        );
        await provider.addCategory(newCategory);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Object catch (e) {
      if (mounted) {
        showCupertinoToast(context, 'Error saving category: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isEditing = widget.category != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: ShapeDecoration(
            color: colorScheme.surface,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 20,
                cornerSmoothing: 0.6,
              ),
              side: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            shadows: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isEditing ? 'Edit Category' : 'Add Category',
                        style: context.textTheme.titleLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () => Navigator.of(context).pop(),
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

              // Form
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Category name
                    CupertinoTextField(
                      controller: _nameController,
                      placeholder: 'Enter category name',
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      prefix: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Icon(
                          Iconsax.text_outline,
                          size: 20,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      style: context.textTheme.bodyLarge.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      placeholderStyle: context.textTheme.bodyLarge.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: SmoothBorderRadius(
                          cornerRadius: 12,
                          cornerSmoothing: 0.6,
                        ),
                        border: Border.all(
                          color: _nameError != null
                              ? colorScheme.error
                              : colorScheme.outline.withValues(alpha: 0.4),
                        ),
                      ),
                      onChanged: (_) {
                        if (_nameError != null) {
                          setState(() => _nameError = null);
                        }
                      },
                    ),
                    if (_nameError != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _nameError!,
                        style: context.textTheme.bodySmall.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Icon selector
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: _selectIcon,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 12,
                              cornerSmoothing: 0.6,
                            ),
                            side: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: ShapeDecoration(
                                color: _selectedColor.withValues(alpha: 0.1),
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 12,
                                    cornerSmoothing: 0.6,
                                  ),
                                ),
                              ),
                              child: Icon(_selectedIcon, color: _selectedColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Select Icon',
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_right,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Color selector
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: _selectColor,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 12,
                              cornerSmoothing: 0.6,
                            ),
                            side: BorderSide(
                              color: colorScheme.outline.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: ShapeDecoration(
                                color: _selectedColor,
                                shape: SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius(
                                    cornerRadius: 12,
                                    cornerSmoothing: 0.6,
                                  ),
                                  side: BorderSide(
                                    color: colorScheme.outline.withValues(
                                      alpha: 0.2,
                                    ),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Select Color',
                                style: context.textTheme.bodyLarge,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_right,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        CupertinoButton.filled(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 12,
                            cornerSmoothing: 0.6,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          onPressed: _isLoading ? null : _saveCategory,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CupertinoActivityIndicator(),
                                )
                              : Text(isEditing ? 'Update' : 'Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
