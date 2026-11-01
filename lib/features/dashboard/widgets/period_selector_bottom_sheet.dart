import 'package:flutter/cupertino.dart';
import 'package:munshi/core/models/period_type.dart';
import 'package:munshi/core/theme.dart';

class PeriodSelectorBottomSheet extends StatelessWidget {
  const PeriodSelectorBottomSheet({
    required this.currentPeriodType,
    required this.onPeriodTypeChanged,
    super.key,
  });
  final PeriodType currentPeriodType;
  final ValueChanged<PeriodType> onPeriodTypeChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Select Report Period',
            style: context.textTheme.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to view your financial data',
            style: context.textTheme.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Period options
          _buildPeriodOption(
            context,
            PeriodType.daily,
            CupertinoIcons.today,
            'Daily',
            'View daily spending and income',
            currentPeriodType == PeriodType.daily,
          ),
          const SizedBox(height: 12),
          _buildPeriodOption(
            context,
            PeriodType.weekly,
            CupertinoIcons.calendar_today,
            'Weekly',
            'View weekly spending patterns',
            currentPeriodType == PeriodType.weekly,
          ),
          const SizedBox(height: 12),
          _buildPeriodOption(
            context,
            PeriodType.monthly,
            CupertinoIcons.calendar,
            'Monthly',
            'View monthly financial overview',
            currentPeriodType == PeriodType.monthly,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(
    BuildContext context,
    PeriodType periodType,
    IconData icon,
    String title,
    String subtitle,
    bool isSelected,
  ) {
    final colorScheme = context.colorScheme;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: () {
        onPeriodTypeChanged(periodType);
        Navigator.of(context).pop();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.08)
              : CupertinoColors.transparent,
        ),
        child: Row(
          children: [
            // Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CupertinoIcons.checkmark_alt,
                  color: colorScheme.onPrimary,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context,
    PeriodType currentPeriodType,
    ValueChanged<PeriodType> onPeriodTypeChanged,
  ) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => PeriodSelectorBottomSheet(
        currentPeriodType: currentPeriodType,
        onPeriodTypeChanged: onPeriodTypeChanged,
      ),
    );
  }
}
