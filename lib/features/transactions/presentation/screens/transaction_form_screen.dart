import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:munshi/core/enums/transaction_type.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/transactions/domain/entities/transaction.dart';
import 'package:munshi/features/transactions/domain/entities/transaction_category.dart';
import 'package:munshi/features/transactions/presentation/widgets/form_builder_category_chips.dart';
import 'package:munshi/widgets/cupertino_toast.dart';

/// A full-screen form for creating a new transaction or editing an existing
/// one.
class TransactionFormScreen extends StatefulWidget {
  /// Creates a [TransactionFormScreen].
  ///
  /// Supply [transaction] to pre-populate the form when editing.
  const TransactionFormScreen({
    required this.onSubmit,
    super.key,
    this.transaction,
  });

  /// The existing transaction to edit, or `null` when creating a new one.
  final Transaction? transaction;

  /// Called with the completed [Transaction] when the form is submitted.
  final void Function(Transaction transaction) onSubmit;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  late TransactionType _selectedType;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  TransactionCategory? _selectedExpenseCategory;
  TransactionCategory? _selectedIncomeCategory;
  late DateTime _selectedDateTime;

  String? _amountError;
  String? _noteError;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.transaction?.type ?? TransactionType.expense;
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _noteController = TextEditingController(
      text: widget.transaction?.note ?? '',
    );
    if (widget.transaction?.category != null) {
      if (_selectedType == TransactionType.expense) {
        _selectedExpenseCategory = widget.transaction!.category;
      } else {
        _selectedIncomeCategory = widget.transaction!.category;
      }
    }
    _selectedDateTime = widget.transaction?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final colorScheme = context.colorScheme;
    final minDate = DateTime.now().subtract(const Duration(days: 365 * 2));
    final maxDate = DateTime.now().add(const Duration(days: 365));

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 300,
          decoration: ShapeDecoration(
            color: colorScheme.surface,
            shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                top: SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.6),
              ),
            ),
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
                      Text(
                        'Select Date & Time',
                        style: context.textTheme.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(popupContext).pop(),
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
                    initialDateTime: _selectedDateTime,
                    minimumDate: minDate,
                    maximumDate: maxDate,
                    onDateTimeChanged: (newDate) {
                      setState(() {
                        _selectedDateTime = newDate;
                      });
                    },
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
    final isEditing = widget.transaction != null;

    return CupertinoPageScaffold(
      backgroundColor: colorScheme.surface,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Iconsax.arrow_left_outline,
            color: colorScheme.onSurface,
          ),
        ),
        middle: Text(
          isEditing ? 'Edit Transaction' : 'Add Transaction',
          style: context.textTheme.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _submitForm,
          child: Text(
            isEditing ? 'Update' : 'Save',
            style: context.textTheme.titleMedium.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Segmented Control for Expense / Income
                  SizedBox(
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
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
                        ),
                        TransactionType.income: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
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
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Amount',
                    style: context.textTheme.titleSmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _amountController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    ],
                    placeholder: 'Enter amount',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(
                        Iconsax.wallet_outline,
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
                        color: _amountError != null
                            ? colorScheme.error
                            : colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    onChanged: (_) {
                      if (_amountError != null) {
                        setState(() => _amountError = null);
                      }
                    },
                  ),
                  if (_amountError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _amountError!,
                      style: context.textTheme.bodySmall.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  Text(
                    'Note',
                    style: context.textTheme.titleSmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _noteController,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    placeholder: _selectedType == TransactionType.expense
                        ? 'What was this for? (Tea, Auto, Lunch, Petrol)'
                        : 'Where did this come from? (Salary, Client, Refund)',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 36),
                      child: Icon(
                        Iconsax.note_outline,
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
                        color: _noteError != null
                            ? colorScheme.error
                            : colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    onChanged: (_) {
                      if (_noteError != null) {
                        setState(() => _noteError = null);
                      }
                    },
                  ),
                  if (_noteError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _noteError!,
                      style: context.textTheme.bodySmall.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  Text(
                    _selectedType == TransactionType.expense
                        ? 'Expense Category'
                        : 'Income Category',
                    style: context.textTheme.titleSmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: FormBuilderCategoryChips(
                      key: ValueKey(_selectedType),
                      name: _selectedType == TransactionType.expense
                          ? 'expense_category'
                          : 'income_category',
                      type: _selectedType,
                      selectedValue: _selectedType == TransactionType.expense
                          ? _selectedExpenseCategory
                          : _selectedIncomeCategory,
                      onChanged: (category) {
                        setState(() {
                          if (_selectedType == TransactionType.expense) {
                            _selectedExpenseCategory = category;
                          } else {
                            _selectedIncomeCategory = category;
                          }
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'Date & Time',
                    style: context.textTheme.titleSmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: _pickDateTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: ShapeDecoration(
                        color: colorScheme.surfaceContainerLow,
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(
                            cornerRadius: 12,
                            cornerSmoothing: 0.6,
                          ),
                          side: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.calendar_edit_outline,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              DateFormat(
                                'd MMM, h:mm a',
                              ).format(_selectedDateTime),
                              style: context.textTheme.bodyLarge.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            CupertinoIcons.chevron_down,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Floating bottom action button
            Positioned(
              right: 20,
              bottom: MediaQuery.paddingOf(context).bottom + 20,
              child: CupertinoButton.filled(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 16,
                  cornerSmoothing: 0.6,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                onPressed: _submitForm,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isEditing
                          ? Iconsax.tick_circle_bold
                          : Iconsax.save_2_bold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEditing ? 'Update' : 'Save',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    final amountText = _amountController.text.trim();
    final noteText = _noteController.text.trim();

    String? amountError;
    String? noteError;

    if (amountText.isEmpty) {
      amountError = 'Amount is required';
    } else {
      final parsedAmount = double.tryParse(amountText);
      if (parsedAmount == null) {
        amountError = 'Please enter a valid number';
      } else if (parsedAmount < 0.01) {
        amountError = 'Amount must be greater than zero';
      }
    }

    if (noteText.length > 200) {
      noteError = 'Note too long';
    }

    if (amountError != null || noteError != null) {
      setState(() {
        _amountError = amountError;
        _noteError = noteError;
      });
      showCupertinoToast(
        context,
        'Please complete the form properly.',
        isError: true,
      );
      return;
    }

    final amount = double.parse(amountText);
    final category = _selectedType == TransactionType.expense
        ? _selectedExpenseCategory
        : _selectedIncomeCategory;
    final description = noteText.isEmpty ? null : noteText;

    final transaction = Transaction(
      id: widget.transaction?.id,
      amount: amount,
      date: _selectedDateTime,
      type: _selectedType,
      categoryId: category?.id,
      note: description,
      category: category,
    );
    widget.onSubmit(transaction);
    Navigator.pop(context);
  }
}
