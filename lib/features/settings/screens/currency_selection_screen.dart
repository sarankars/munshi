import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:munshi/core/models/currency.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/providers/currency_provider.dart';
import 'package:provider/provider.dart';

class CurrencySelectionScreen extends StatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  State<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late List<Animation<Offset>> _itemAnimations;

  final TextEditingController _searchController = TextEditingController();
  List<Currency> _filteredCurrencies = SupportedCurrencies.currencies;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Create staggered animations for currency items
    _itemAnimations = List<Animation<Offset>>.generate(
      _filteredCurrencies.length.clamp(
        0,
        10,
      ), // Limit animations for performance
      (int index) =>
          Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.05,
                0.3 + (index * 0.05),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
    );

    _animationController.forward();

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filteredCurrencies = SupportedCurrencies.searchCurrencies(_searchQuery);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _selectCurrency(Currency currency) {
    HapticFeedback.lightImpact();
    context.read<CurrencyProvider>().setSelectedCurrency(currency);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final currentCurrency = context.watch<CurrencyProvider>().selectedCurrency;

    return CupertinoPageScaffold(
      backgroundColor: colorScheme.surface,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            CupertinoIcons.back,
            color: colorScheme.onSurface,
          ),
        ),
        middle: Text(
          'Select Currency',
          style: context.textTheme.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Search bar
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: CupertinoSearchTextField(
                  controller: _searchController,
                  placeholder: 'Search currencies...',
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  style: context.textTheme.bodyMedium.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  placeholderStyle: context.textTheme.bodyMedium.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  backgroundColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            // Currency list
            Expanded(
              child: _filteredCurrencies.isEmpty
                  ? _buildEmptyState(colorScheme)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredCurrencies.length,
                      itemBuilder: (context, index) {
                        final currency = _filteredCurrencies[index];
                        final isSelected = currency == currentCurrency;
                        final animationIndex = index.clamp(
                          0,
                          _itemAnimations.length - 1,
                        );

                        return SlideTransition(
                          position: _itemAnimations[animationIndex],
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                onPressed: () => _selectCurrency(currency),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colorScheme.primaryContainer
                                              .withValues(alpha: 0.8)
                                        : colorScheme.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? colorScheme.primary.withValues(
                                              alpha: 0.3,
                                            )
                                          : colorScheme.outline.withValues(
                                              alpha: 0.2,
                                            ),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: colorScheme.shadow
                                                  .withValues(alpha: 0.08),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      // Flag and symbol
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? colorScheme.primary.withValues(
                                                  alpha: 0.1,
                                                )
                                              : colorScheme
                                                    .surfaceContainerHighest
                                                    .withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              currency.flag,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              currency.symbol,
                                              style: context.textTheme.bodySmall
                                                  .copyWith(
                                                    color: isSelected
                                                        ? colorScheme.primary
                                                        : colorScheme.onSurface
                                                              .withValues(
                                                                alpha: 0.7,
                                                              ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      // Currency details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currency.name,
                                              style: context
                                                  .textTheme
                                                  .titleMedium
                                                  .copyWith(
                                                    color: isSelected
                                                        ? colorScheme
                                                              .onPrimaryContainer
                                                        : colorScheme.onSurface,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  currency.code,
                                                  style: context
                                                      .textTheme
                                                      .bodyMedium
                                                      .copyWith(
                                                        color: isSelected
                                                            ? colorScheme
                                                                  .onPrimaryContainer
                                                                  .withValues(
                                                                    alpha: 0.8,
                                                                  )
                                                            : colorScheme
                                                                  .onSurface
                                                                  .withValues(
                                                                    alpha: 0.7,
                                                                  ),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? colorScheme.primary
                                                              .withValues(
                                                                alpha: 0.2,
                                                              )
                                                        : colorScheme.outline
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    currency.symbol,
                                                    style: context
                                                        .textTheme
                                                        .bodySmall
                                                        .copyWith(
                                                          color: isSelected
                                                              ? colorScheme
                                                                    .primary
                                                              : colorScheme
                                                                    .onSurface
                                                                    .withValues(
                                                                      alpha:
                                                                          0.7,
                                                                    ),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ],
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
                                            size: 16,
                                            color: colorScheme.onPrimary,
                                          ),
                                        )
                                      else
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: colorScheme.outline
                                                  .withValues(alpha: 0.3),
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.search_normal_outline,
                size: 48,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No currencies found',
              style: context.textTheme.titleLarge.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with a different term',
              style: context.textTheme.bodyMedium.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
