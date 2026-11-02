import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/transactions/domain/entities/daily_transactions.dart';
import 'package:munshi/features/transactions/domain/entities/transaction.dart';
import 'package:munshi/features/transactions/presentation/widgets/transaction_tile.dart';

/// A list widget that groups transactions by calendar day.
class GroupedTransactionList extends StatefulWidget {
  /// Creates a [GroupedTransactionList].
  const GroupedTransactionList({
    required this.groupedTransactions,
    required this.onTap,
    super.key,
    this.onDelete,
    this.onEdit,
    this.onCategoryTap,
    this.controller,
    this.isLoadingMore = false,
  });
  // Indent for dividers to align with ListTile title text
  // Accounts for leading widget (56dp) + horizontal padding (16dp)
  static const double _kDividerIndent = 72;

  /// Transactions grouped by day to render.
  final List<DailyTransactions> groupedTransactions;

  /// Called when a transaction tile is tapped.
  final void Function(Transaction) onTap;

  /// Called when a transaction is deleted via the swipe action.
  final Future<void> Function(Transaction transaction)? onDelete;

  /// Called when a transaction is edited via the swipe action.
  final Future<void> Function(Transaction transaction)? onEdit;

  /// Called when the category chip of a transaction is tapped.
  final void Function(Transaction)? onCategoryTap;

  /// Optional scroll controller for the underlying list.
  final ScrollController? controller;

  /// Whether a next-page load is in progress (shows a bottom spinner).
  final bool isLoadingMore;

  @override
  State<GroupedTransactionList> createState() => _GroupedTransactionListState();
}

class _GroupedTransactionListState extends State<GroupedTransactionList>
    with SingleTickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.7, curve: Curves.easeOut),
      ),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: widget.groupedTransactions.isEmpty && !widget.isLoadingMore
                ? _buildEmptyState(colorScheme)
                : SlidableAutoCloseBehavior(
                    child: CupertinoScrollbar(
                      controller: widget.controller,
                      radius: const SmoothRadius(
                        cornerRadius: 4,
                        cornerSmoothing: 0.6,
                      ),
                      child: ListView(
                        controller: widget.controller,
                        padding: const EdgeInsets.only(bottom: 110),
                        children: [
                          ..._buildGroupedTransactionWidgets(colorScheme),
                          if (widget.isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  List<Widget> _buildGroupedTransactionWidgets(AppColorScheme colorScheme) {
    final widgets = <Widget>[];
    var globalIndex = 0;

    for (final (groupIndex, group) in widget.groupedTransactions.indexed) {
      final date = group.date;
      final transactions = group.transactions;

      // Add date divider
      widgets.add(_buildDateDivider(date, globalIndex));
      globalIndex++;

      // Add transactions for this date
      for (
        var transactionIndex = 0;
        transactionIndex < transactions.length;
        transactionIndex++
      ) {
        final transaction = transactions[transactionIndex];
        widgets.add(_buildAnimatedTransactionTile(transaction, globalIndex));
        globalIndex++;

        // Add separator if not the last transaction of the date
        if (transactionIndex < transactions.length - 1) {
          widgets.add(
            Container(
              height: 1,
              margin: const EdgeInsets.only(
                left: GroupedTransactionList._kDividerIndent,
              ),
              color: colorScheme.outline.withValues(alpha: 0.15),
            ),
          );
        }
      }

      // Add spacing between date groups (except for the last group)
      if (groupIndex < widget.groupedTransactions.length - 1) {
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  Widget _buildDateDivider(DateTime date, int index) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    String displayText;
    if (transactionDate == today) {
      displayText = 'Today';
    } else if (transactionDate == yesterday) {
      displayText = 'Yesterday';
    } else {
      displayText = DateFormat('EEEE, MMM d, yyyy').format(date);
    }

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 80)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final slideValue = Curves.easeOutCubic.transform(value);
        final fadeValue = Curves.easeOut.transform(value);
        final colorScheme = context.colorScheme;

        return Transform.translate(
          offset: Offset(0, 30 * (1 - slideValue)),
          child: Opacity(
            opacity: fadeValue,
            child: Container(
              padding: const EdgeInsets.only(
                right: 16,
                left: 16,
                top: 10,
                bottom: 2,
              ),
              child: Row(
                children: [
                  Text(
                    displayText,
                    style: context.textTheme.titleSmall.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTransactionTile(
    Transaction transaction,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(transaction.id),
      duration: Duration(milliseconds: 600 + (index * 80)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final slideValue = Curves.easeOutCubic.transform(value);
        final fadeValue = Curves.easeOut.transform(value);
        final scaleValue = 0.95 + (0.05 * Curves.easeOutBack.transform(value));

        return Transform.scale(
          scale: scaleValue,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - slideValue)),
            child: Opacity(
              opacity: fadeValue,
              child: TransactionTile(
                transaction: transaction,
                onTap: () {
                  widget.onTap(transaction);
                },
                onDelete: widget.onDelete,
                onEdit: widget.onEdit,
                onCategoryTap: widget.onCategoryTap != null
                    ? () => widget.onCategoryTap!(transaction)
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(AppColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: ShapeDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 24,
                  cornerSmoothing: 0.6,
                ),
              ),
            ),
            child: Icon(
              CupertinoIcons.doc_text,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No transactions found',
            style: context.textTheme.headlineSmall.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: context.textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
