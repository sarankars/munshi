import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:munshi/core/theme.dart';
import 'package:munshi/features/categories/screens/categories_screen.dart';
import 'package:munshi/features/dashboard/providers/dashboard_provider.dart';
import 'package:munshi/features/dashboard/screens/home_screen.dart';
import 'package:munshi/features/settings/screens/settings_screen.dart';
import 'package:munshi/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:munshi/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:munshi/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:munshi/features/transactions/presentation/screens/transaction_form_screen.dart';
import 'package:munshi/features/transactions/presentation/screens/transactions_screen.dart';

/// The root scaffold that hosts the liquid glass bottom navigation bar and
/// action button.
///
/// It also listens for [TransactionState.transactionMutated] and refreshes the
/// [DashboardProvider] whenever a transaction is added, updated, or deleted.
class MainScreen extends StatefulWidget {
  /// Creates a [MainScreen].
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<GlassTab> _tabs = [
    GlassTab(
      icon: Icon(Iconsax.home_outline),
      activeIcon: Icon(Iconsax.home_1_bold),
      label: 'Home',
    ),
    GlassTab(
      icon: Icon(Iconsax.receipt_item_outline),
      activeIcon: Icon(Iconsax.receipt_item_bold),
      label: 'History',
    ),
    GlassTab(
      icon: Icon(Iconsax.category_outline),
      activeIcon: Icon(Iconsax.category_bold),
      label: 'Categories',
    ),
    GlassTab(
      icon: Icon(Iconsax.setting_2_outline),
      activeIcon: Icon(Iconsax.setting_2_bold),
      label: 'Settings',
    ),
  ];

  // Build screens dynamically to reflect currency changes
  List<Widget> get _screens => const [
    HomeScreen(),
    TransactionsScreen(),
    CategoriesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return BlocListener<TransactionBloc, TransactionState>(
      listenWhen: (previous, current) =>
          !previous.transactionMutated && current.transactionMutated,
      listener: (context, state) {
        // Refresh the dashboard whenever a transaction is mutated.
        unawaited(context.read<DashboardProvider>().refresh());
      },
      child: GlassScaffold(
        backgroundColor: colorScheme.surface,
        contentAwareBrightness: true,
        bottomBar: GlassTabBar.bottom(
          adaptiveBrightness: true,
          selectedIndex: _selectedIndex,
          onTabSelected: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          selectedIconColor: colorScheme.primary,
          selectedLabelColor: colorScheme.primary,
          tabs: _tabs,
          extraButton: GlassTabBarExtraButton(
            icon: const Icon(Iconsax.add_outline),
            label: 'Add transaction',
            iconColor: colorScheme.primary,
            onTap: () async {
              await Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (context) {
                    return TransactionFormScreen(
                      onSubmit: (transaction) {
                        context.read<TransactionBloc>().add(
                          TransactionAdded(transaction),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
        body: IndexedStack(
          alignment: Alignment.topCenter,
          index: _selectedIndex,
          children: [
            for (final (index, screen) in _screens.indexed)
              HeroMode(
                enabled: index == _selectedIndex,
                child: screen,
              ),
          ],
        ),
      ),
    );
  }
}
