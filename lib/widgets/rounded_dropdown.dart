import 'package:flutter/cupertino.dart';
import 'package:munshi/core/theme.dart';

/// An item in a [RoundedDropdown].
class RoundedDropdownItem<T> {
  /// Creates a [RoundedDropdownItem].
  const RoundedDropdownItem({
    required this.value,
    required this.child,
    this.label,
  });

  /// The value represented by this item.
  final T value;

  /// The widget displayed for this item.
  final Widget child;

  /// Optional plain text label for action sheet display.
  final String? label;
}

/// A custom Cupertino-styled dropdown widget with rounded corners.
///
/// Opens a [CupertinoActionSheet] modal popup when tapped.
class RoundedDropdown<T> extends StatelessWidget {
  /// Creates a rounded dropdown with customizable styling.
  const RoundedDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
    this.title,
    this.icon,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
    this.contentPadding,
  });

  /// The currently selected value for the dropdown.
  final T? value;

  /// The list of items to display in the selection menu.
  final List<RoundedDropdownItem<T>> items;

  /// Callback function triggered when a new value is selected.
  final ValueChanged<T?>? onChanged;

  /// Optional title shown at the top of the Cupertino action sheet.
  final String? title;

  /// Custom icon widget for the dropdown. Defaults to a chevron down icon.
  final Widget? icon;

  /// Border radius for the container. Defaults to 12.0.
  final double borderRadius;

  /// Background color for the dropdown container.
  final Color? backgroundColor;

  /// Border color for the dropdown container.
  final Color? borderColor;

  /// Padding inside the dropdown container.
  final EdgeInsetsGeometry? contentPadding;

  Future<void> _showPickerSheet(BuildContext context) async {
    if (onChanged == null || items.isEmpty) return;

    final selected = await showCupertinoModalPopup<T>(
      context: context,
      builder: (sheetContext) {
        return CupertinoActionSheet(
          title: title != null ? Text(title!) : null,
          actions: items.map((item) {
            final isSelected = item.value == value;
            return CupertinoActionSheetAction(
              isDefaultAction: isSelected,
              onPressed: () => Navigator.of(sheetContext).pop(item.value),
              child: item.child,
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(sheetContext).pop(),
            child: const Text('Cancel'),
          ),
        );
      },
    );

    if (selected != null) {
      onChanged!(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final selectedItem = items.where((item) => item.value == value).firstOrNull;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onChanged == null ? null : () => _showPickerSheet(context),
      child: Container(
        padding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedItem != null)
              DefaultTextStyle(
                style: context.textTheme.bodyMedium.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                child: selectedItem.child,
              ),
            const SizedBox(width: 6),
            icon ??
                Icon(
                  CupertinoIcons.chevron_down,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 14,
                ),
          ],
        ),
      ),
    );
  }
}
