import 'package:flutter/cupertino.dart';
import 'package:munshi/core/extensions/currency_extensions.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/presentation/extensions/transaction_category_ui_extensions.dart';

class CategoryTile extends StatefulWidget {
  const CategoryTile({
    required this.category,
    required this.onTap,
    super.key,
    this.spendingAmount = 0.0,
    this.transactionCount = 0,
    this.animationDelay = const Duration(),
  });

  final TransactionCategory? category;
  final VoidCallback onTap;
  final double spendingAmount;
  final int transactionCount;
  final Duration animationDelay;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryController,
            curve: const Cubic(0.165, 0.84, 0.44, 1), // iOS easeOutQuart
          ),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    // Start animations after delay
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _entryController.forward();
        _scaleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    // Format spending amount using currency extension
    final formattedAmount = widget.spendingAmount > 0
        ? widget.spendingAmount.toCurrency()
        : 0.toCurrency();

    final categoryColor =
        widget.category?.displayColor ?? CupertinoColors.systemGrey;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.surface,
                      colorScheme.surface.withValues(alpha: 0.8),
                    ],
                  ),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon container with background
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        widget.category?.displayIcon ??
                            CupertinoIcons.question_circle,
                        color: categoryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Category name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.category?.name ?? 'Uncategorized',
                            style: context.textTheme.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                formattedAmount,
                                style: context.textTheme.bodySmall.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '• ${widget.transactionCount} transactions',
                                style: context.textTheme.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Trailing arrow with background
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        CupertinoIcons.chevron_right,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
