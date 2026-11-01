import 'package:flutter/cupertino.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:munshi/core/theme.dart';

class IconPickerDialog extends StatefulWidget {
  const IconPickerDialog({super.key, this.selectedIcon});

  final IconData? selectedIcon;

  @override
  State<IconPickerDialog> createState() => _IconPickerDialogState();
}

class _IconPickerDialogState extends State<IconPickerDialog> {
  late IconData? _selectedIcon;
  String _searchQuery = '';

  // Curated list of commonly used icons from Iconsax
  final List<IconData> _icons = [
    // Finance & Money
    Iconsax.wallet_outline,
    Iconsax.money_outline,
    Iconsax.card_outline,
    Iconsax.dollar_circle_outline,
    Iconsax.coin_outline,

    // Food & Dining
    Iconsax.reserve_outline,
    Iconsax.coffee_outline,
    Iconsax.cake_outline,

    // Transportation
    Iconsax.car_outline,
    Iconsax.bus_outline,
    Iconsax.airplane_outline,
    Iconsax.ship_outline,
    Iconsax.gas_station_outline,

    // Shopping
    Iconsax.shopping_bag_outline,
    Iconsax.shopping_cart_outline,
    Iconsax.tag_outline,
    Iconsax.bag_outline,

    // Entertainment
    Iconsax.music_outline,
    Iconsax.video_play_outline,
    Iconsax.game_outline,
    Iconsax.ticket_outline,
    Iconsax.headphone_outline,

    // Healthcare
    Iconsax.health_outline,
    Iconsax.heart_outline,
    Iconsax.hospital_outline,
    Iconsax.activity_outline,

    // Work & Business
    Iconsax.briefcase_outline,
    Iconsax.shop_outline,
    Iconsax.code_outline,
    Iconsax.chart_outline,
    Iconsax.bank_outline,

    // Home & Living
    Iconsax.home_outline,
    Iconsax.lamp_outline,
    Iconsax.building_outline,
    Iconsax.electricity_outline,

    // Education
    Iconsax.book_outline,
    Iconsax.teacher_outline,
    Iconsax.award_outline,

    // Gifts & Others
    Iconsax.gift_outline,
    Iconsax.more_outline,
    Iconsax.star_outline,
    Iconsax.crown_outline,

    // Bills & Utilities
    Iconsax.receipt_outline,
    Iconsax.document_outline,
    Iconsax.receipt_item_outline,

    // Sports & Fitness
    Iconsax.weight_outline,
    Iconsax.flag_outline,

    // Pets & Animals
    Iconsax.pet_outline,

    // Beauty & Personal Care
    Iconsax.scissor_outline,
    Iconsax.brush_outline,

    // Communication
    Iconsax.call_outline,
    Iconsax.message_outline,
    Iconsax.sms_outline,

    // Technology
    Iconsax.mobile_outline,
    Iconsax.monitor_outline,
    Iconsax.wifi_outline,

    // Clothing
    Iconsax.shopping_cart_outline,

    // Additional
    Iconsax.trend_up_outline,
    Iconsax.trend_down_outline,
    Iconsax.percentage_circle_outline,
    Iconsax.box_outline,
    Iconsax.category_outline,
    Iconsax.setting_outline,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
  }

  List<IconData> get _filteredIcons {
    if (_searchQuery.isEmpty) return _icons;
    return _icons;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select Icon',
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

              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: CupertinoSearchTextField(
                  placeholder: 'Search icons...',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  style: context.textTheme.bodyMedium.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  backgroundColor: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),

              // Icons grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filteredIcons.length,
                  itemBuilder: (context, index) {
                    final icon = _filteredIcons[index];
                    final isSelected =
                        _selectedIcon?.codePoint == icon.codePoint;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : CupertinoColors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Action buttons
              Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      onPressed: _selectedIcon == null
                          ? null
                          : () => Navigator.of(context).pop(_selectedIcon),
                      child: const Text('Select'),
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
