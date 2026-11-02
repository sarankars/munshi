import 'dart:async';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/core/extensions/currency_extensions.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/transactions/domain/entities/transaction.dart';
import 'package:munshi/features/transactions/presentation/extensions/transaction_category_ui_extensions.dart';
import 'package:munshi/widgets/cupertino_toast.dart';

/// A swipeable list tile that represents a single transaction.
class TransactionTile extends StatefulWidget {
  /// Creates a [TransactionTile].
  const TransactionTile({
    required this.onTap,
    required this.transaction,
    super.key,
    this.onDelete,
    this.onEdit,
    this.onCategoryTap,
  });

  /// Called when the tile is tapped (opens the detail sheet).
  final VoidCallback onTap;

  /// The transaction to display.
  final Transaction transaction;

  /// Called when the user swipes to delete.
  final Future<void> Function(Transaction transaction)? onDelete;

  /// Called when the user swipes to edit.
  final Future<void> Function(Transaction transaction)? onEdit;

  /// Called when the category chip is tapped.
  final VoidCallback? onCategoryTap;

  @override
  State<TransactionTile> createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile>
    with SingleTickerProviderStateMixin {
  late final SlidableController controller;

  @override
  void initState() {
    super.initState();
    controller = SlidableController(this);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final categoryColor =
        widget.transaction.category?.displayColor ?? CupertinoColors.systemGrey;

    return Slidable(
      controller: controller,
      key: ValueKey(widget.transaction.id),
      groupTag: 'transactions',
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        dismissible: DismissiblePane(
          confirmDismiss: _showDeleteConfirmationDialog,
          closeOnCancel: true,
          onDismissed: _deleteTransaction,
        ),
        children: [
          SlidableAction(
            onPressed: (context) => _editTransaction(),
            backgroundColor: colorScheme.inverseSurface,
            foregroundColor: colorScheme.onInverseSurface,
            icon: Iconsax.edit_outline,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) async {
              final confirm = await _showDeleteConfirmationDialog();
              if (confirm) {
                await _deleteTransaction();
              }
            },
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
            icon: Iconsax.trash_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: CupertinoListTile(
        onTap: widget.onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leadingSize: 44,
        leading: GestureDetector(
          onTap: widget.onCategoryTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: ShapeDecoration(
              color: categoryColor.withValues(alpha: 0.12),
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 12,
                  cornerSmoothing: 0.6,
                ),
              ),
            ),
            child: Icon(
              widget.transaction.category?.displayIcon ??
                  Iconsax.category_outline,
              color: categoryColor,
              size: 22,
            ),
          ),
        ),
        title: Text(
          widget.transaction.note ??
              widget.transaction.category?.name ??
              'Uncategorized',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyLarge.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          DateFormat('d MMM • h:mm a').format(widget.transaction.date),
          style: context.textTheme.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Text(
          widget.transaction.amount.toTransactionCurrency(
            isExpense: widget.transaction.type == TransactionType.expense,
          ),
          style: context.textTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.transaction.type == TransactionType.expense
                ? colorScheme.error
                : colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Future<void> _deleteTransaction() async {
    if (widget.onDelete != null) {
      await widget.onDelete!(widget.transaction);
    }
    if (mounted) {
      showCupertinoToast(context, 'Transaction deleted');
    }
  }

  void _editTransaction() {
    final onEdit = widget.onEdit;
    if (onEdit != null) {
      unawaited(onEdit(widget.transaction));
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this transaction?',
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
    return result ?? false;
  }
}
