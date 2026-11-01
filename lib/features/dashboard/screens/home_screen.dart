import 'package:flutter/cupertino.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/dashboard/providers/dashboard_provider.dart';
import 'package:munshi/features/dashboard/widgets/dashboard_categories_widget.dart';
import 'package:munshi/features/dashboard/widgets/dashboard_stats_widget.dart';
import 'package:munshi/features/dashboard/widgets/dashboard_summary_card.dart';
import 'package:munshi/features/dashboard/widgets/greeting_text.dart';
import 'package:munshi/features/dashboard/widgets/period_selector_bottom_sheet.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final colorScheme = context.colorScheme;
        return CupertinoPageScaffold(
          backgroundColor: colorScheme.surface,
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: dashboardProvider.refresh,
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const GreetingText(),
                              Text(
                                'Dashboard',
                                style: context.textTheme.headlineSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  minimumSize: Size.zero,
                                  onPressed: () =>
                                      dashboardProvider.changePeriod(-1),
                                  child: Icon(
                                    CupertinoIcons.chevron_left,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 16,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => PeriodSelectorBottomSheet.show(
                                    context,
                                    dashboardProvider.currentPeriodType,
                                    dashboardProvider.changePeriodType,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      dashboardProvider
                                          .selectedPeriod
                                          .displayName,
                                      style: context.textTheme.bodyMedium
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ),
                                CupertinoButton(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  minimumSize: Size.zero,
                                  onPressed: dashboardProvider.isCurrentPeriod
                                      ? null
                                      : () => dashboardProvider.changePeriod(1),
                                  child: Icon(
                                    CupertinoIcons.chevron_right,
                                    color: dashboardProvider.isCurrentPeriod
                                        ? colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.3)
                                        : colorScheme.onSurfaceVariant,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const DashboardSummaryCard(),
                      const SizedBox(height: 15),
                      // Quick Stats Row
                      const Row(
                        children: [
                          Expanded(
                            child: DashboardStatsWidget(
                              statType: DashboardStatType.transactions,
                              animationDelay: Duration(milliseconds: 200),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: DashboardStatsWidget(
                              statType: DashboardStatType.biggestSpend,
                              animationDelay: Duration(milliseconds: 350),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Categories Breakdown
                      const DashboardCategoriesWidget(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
