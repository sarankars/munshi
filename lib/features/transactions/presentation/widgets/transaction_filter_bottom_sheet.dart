import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/categories/providers/category_provider.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/domain/value_objects/transaction_filter.dart';
import 'package:munshi/features/transactions/presentation/extensions/transaction_category_ui_extensions.dart';
import 'package:munshi/providers/currency_provider.dart';
import 'package:provider/provider.dart';

class TransactionFilterBottomSheet extends StatefulWidget {
  const TransactionFilterBottomSheet({
    required this.initialFilter,
    required this.onApplyFilter,
    super.key,
  });
  final TransactionFilter initialFilter;
  final void Function(TransactionFilter) onApplyFilter;

  @override
  State<TransactionFilterBottomSheet> createState() =>
      _TransactionFilterBottomSheetState();
}

class _TransactionFilterBottomSheetState
    extends State<TransactionFilterBottomSheet> {
  int _selectedTabIndex = 0;
  late TransactionFilter _workingFilter;
  final _minAmountController = TextEditingController();
  final _maxAmountController = TextEditingController();

  final List<String> _timeframeOptions = [
    'Today',
    'This Week',
    'This Month',
    'Last Month',
    'This Year',
  ];

  @override
  void initState() {
    super.initState();
    _workingFilter = widget.initialFilter;

    // Initialize amount controllers
    if (_workingFilter.minAmount != null) {
      _minAmountController.text = _workingFilter.minAmount!.toStringAsFixed(2);
    }
    if (_workingFilter.maxAmount != null) {
      _maxAmountController.text = _workingFilter.maxAmount!.toStringAsFixed(2);
    }

    // Add listeners to update UI when text changes
    _minAmountController.addListener(() {
      setState(() {});
    });
    _maxAmountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickCupertinoDate({
    required DateTime initialDate,
    required DateTime minimumDate,
    required DateTime maximumDate,
    required String title,
  }) async {
    final colorScheme = context.colorScheme;
    var tempDate = initialDate;

    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(popupContext).pop(),
                        child: const Text('Cancel'),
                      ),
                      Text(
                        title,
                        style: context.textTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () =>
                            Navigator.of(popupContext).pop(tempDate),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    minimumDate: minimumDate,
                    maximumDate: maximumDate,
                    onDateTimeChanged: (date) => tempDate = date,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                Text(
                  'Filter & Sort',
                  style: context.textTheme.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (_workingFilter.hasActiveFilters)
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () {
                      setState(() {
                        _workingFilter = TransactionFilter.empty();
                        _minAmountController.clear();
                        _maxAmountController.clear();
                      });
                    },
                    child: const Text('Clear All'),
                  ),
              ],
            ),
          ),

          // Segmented Control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedTabIndex,
                backgroundColor: colorScheme.surfaceContainerHighest,
                thumbColor: colorScheme.surface,
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedTabIndex = value);
                  }
                },
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Date'),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Amount'),
                  ),
                  2: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Type'),
                  ),
                  3: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('Category'),
                  ),
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Tab Views
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: [
                _buildDateFilterTab(colorScheme),
                _buildAmountFilterTab(colorScheme),
                _buildTypeFilterTab(colorScheme),
                _buildCategoryFilterTab(colorScheme),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              16,
              24,
              MediaQuery.paddingOf(context).bottom + 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: context.textTheme.bodyLarge.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    borderRadius: BorderRadius.circular(16),
                    onPressed: () {
                      // Parse amount filters
                      final minAmount = double.tryParse(
                        _minAmountController.text,
                      );
                      final maxAmount = double.tryParse(
                        _maxAmountController.text,
                      );

                      final finalFilter = _workingFilter.copyWith(
                        minAmount: minAmount,
                        maxAmount: maxAmount,
                        clearMinAmount: _minAmountController.text.isEmpty,
                        clearMaxAmount: _maxAmountController.text.isEmpty,
                      );

                      widget.onApplyFilter(finalFilter);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateFilterTab(AppColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Periods',
            style: context.textTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeframeOptions.map((timeframe) {
              final isSelected =
                  _workingFilter.datePeriod?.displayName ==
                  TransactionFilter.fromTimeframe(
                    timeframe,
                  ).datePeriod?.displayName;
              return _CupertinoFilterChip(
                label: timeframe,
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _workingFilter = TransactionFilter.fromTimeframe(
                        timeframe,
                      );
                    } else {
                      _workingFilter = _workingFilter.copyWith(
                        clearDatePeriod: true,
                      );
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Custom Range',
            style: context.textTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () async {
                    final now = DateTime.now();
                    final initial = _workingFilter.customStartDate ?? now;
                    final startDate = await _pickCupertinoDate(
                      initialDate: initial.isAfter(now) ? now : initial,
                      minimumDate: DateTime(2020),
                      maximumDate: now,
                      title: 'Start Date',
                    );
                    if (startDate != null) {
                      setState(() {
                        _workingFilter = _workingFilter.copyWith(
                          customStartDate: startDate,
                          clearDatePeriod: true,
                        );
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.calendar,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _workingFilter.customStartDate != null
                              ? DateFormat(
                                  'd MMM y',
                                ).format(_workingFilter.customStartDate!)
                              : 'Start Date',
                          style: context.textTheme.bodyMedium.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () async {
                    final now = DateTime.now();
                    final minDate =
                        _workingFilter.customStartDate ?? DateTime(2020);
                    var initial = _workingFilter.customEndDate ?? now;
                    if (initial.isBefore(minDate)) {
                      initial = minDate;
                    }
                    final endDate = await _pickCupertinoDate(
                      initialDate: initial,
                      minimumDate: minDate,
                      maximumDate: now,
                      title: 'End Date',
                    );
                    if (endDate != null) {
                      setState(() {
                        _workingFilter = _workingFilter.copyWith(
                          customEndDate: endDate,
                          clearDatePeriod: true,
                        );
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.calendar,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _workingFilter.customEndDate != null
                              ? DateFormat(
                                  'd MMM y',
                                ).format(_workingFilter.customEndDate!)
                              : 'End Date',
                          style: context.textTheme.bodyMedium.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_workingFilter.customStartDate != null ||
              _workingFilter.customEndDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                onPressed: () {
                  setState(() {
                    _workingFilter = _workingFilter.copyWith(
                      clearCustomStartDate: true,
                      clearCustomEndDate: true,
                    );
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.xmark_circle,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Clear Custom Range',
                      style: context.textTheme.bodyMedium.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAmountFilterTab(AppColorScheme colorScheme) {
    final currencySymbol = context
        .watch<CurrencyProvider>()
        .selectedCurrency
        .symbol;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Range',
            style: context.textTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Minimum Amount',
            style: context.textTheme.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          CupertinoTextField(
            controller: _minAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            placeholder: '0.00',
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.wallet_1_outline,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    currencySymbol,
                    style: context.textTheme.bodyLarge.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            suffix: _minAmountController.text.isNotEmpty
                ? CupertinoButton(
                    padding: const EdgeInsets.only(right: 10),
                    minimumSize: Size.zero,
                    onPressed: _minAmountController.clear,
                    child: Icon(
                      CupertinoIcons.clear_circled_solid,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Maximum Amount',
            style: context.textTheme.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          CupertinoTextField(
            controller: _maxAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            placeholder: '0.00',
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.wallet_1_outline,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    currencySymbol,
                    style: context.textTheme.bodyLarge.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            suffix: _maxAmountController.text.isNotEmpty
                ? CupertinoButton(
                    padding: const EdgeInsets.only(right: 10),
                    minimumSize: Size.zero,
                    onPressed: _maxAmountController.clear,
                    child: Icon(
                      CupertinoIcons.clear_circled_solid,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilterTab(AppColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Type',
            style: context.textTheme.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TransactionType.values.map((type) {
              final isSelected = _workingFilter.types?.contains(type) ?? false;
              return _CupertinoFilterChip(
                label: type.name.toUpperCase(),
                selected: isSelected,
                leading: Icon(
                  type == TransactionType.income
                      ? Iconsax.arrow_down_outline
                      : Iconsax.arrow_up_outline,
                  size: 16,
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : (type == TransactionType.income
                            ? CupertinoColors.systemGreen
                            : CupertinoColors.systemRed),
                ),
                onSelected: (selected) {
                  setState(() {
                    final currentTypes =
                        _workingFilter.types?.toSet() ?? <TransactionType>{};
                    if (selected) {
                      currentTypes.add(type);
                    } else {
                      currentTypes.remove(type);
                    }
                    _workingFilter = _workingFilter.copyWith(
                      types: currentTypes.isEmpty ? null : currentTypes,
                      clearTypes: currentTypes.isEmpty,
                    );
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterTab(AppColorScheme colorScheme) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: context.textTheme.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              // Expense Categories
              Text(
                'Expense Categories',
                style: context.textTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categoryProvider.expenseCategories.map((category) {
                  final isSelected =
                      _workingFilter.categories?.contains(category) ?? false;
                  return _CupertinoFilterChip(
                    label: category.name,
                    selected: isSelected,
                    leading: Icon(
                      category.displayIcon,
                      size: 16,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : category.displayColor,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        final currentCategories =
                            _workingFilter.categories?.toSet() ??
                            <TransactionCategory>{};
                        if (selected) {
                          currentCategories.add(category);
                        } else {
                          currentCategories.remove(category);
                        }
                        _workingFilter = _workingFilter.copyWith(
                          categories: currentCategories.isEmpty
                              ? null
                              : currentCategories,
                          clearCategories: currentCategories.isEmpty,
                        );
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Income Categories
              Text(
                'Income Categories',
                style: context.textTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categoryProvider.incomeCategories.map((category) {
                  final isSelected =
                      _workingFilter.categories?.contains(category) ?? false;
                  return _CupertinoFilterChip(
                    label: category.name,
                    selected: isSelected,
                    leading: Icon(
                      category.displayIcon,
                      size: 16,
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : category.displayColor,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        final currentCategories =
                            _workingFilter.categories?.toSet() ??
                            <TransactionCategory>{};
                        if (selected) {
                          currentCategories.add(category);
                        } else {
                          currentCategories.remove(category);
                        }
                        _workingFilter = _workingFilter.copyWith(
                          categories: currentCategories.isEmpty
                              ? null
                              : currentCategories,
                          clearCategories: currentCategories.isEmpty,
                        );
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CupertinoFilterChip extends StatelessWidget {
  const _CupertinoFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.leading,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: () => onSelected(!selected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: context.textTheme.bodyMedium.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
