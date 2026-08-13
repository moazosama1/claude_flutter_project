import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/di.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../core/responsive/app_measurements.dart';
import '../../budgets/view_model/budgets_events.dart';
import '../../budgets/view_model/budgets_view_model.dart';
import '../../dashboard/view_model/dashboard_events.dart';
import '../../dashboard/view_model/dashboard_view_model.dart';
import '../../transactions/view_model/transactions_events.dart';
import '../../transactions/view_model/transactions_view_model.dart';
import 'main_nav_tab.dart';

/// Shell for the app's primary feature tabs (Dashboard, Transactions,
/// Settings). Wrapped by `StatefulShellRoute` in `AppRouter`. The
/// [navigationShell] provided by go_router owns the branch state, so this
/// widget stays purely presentational.
class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final tabs = <MainNavTabSpec>[
      MainNavTabSpec(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard_rounded,
        label: context.l10n.dashboardTitle,
      ),
      MainNavTabSpec(
        icon: Icons.swap_horiz_outlined,
        activeIcon: Icons.swap_horiz_rounded,
        label: context.l10n.transactionsTitle,
      ),
      MainNavTabSpec(
        icon: Icons.savings_outlined,
        activeIcon: Icons.savings_rounded,
        label: context.l10n.budgetsTitle,
      ),
      MainNavTabSpec(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        label: context.l10n.settingsTitle,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(
          left: AppMeasurements.paddingMedium,
          right: AppMeasurements.paddingMedium,
          bottom: AppMeasurements.paddingSmall,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(
              AppMeasurements.radiusExtraLarge,
            ),
            boxShadow: [
              BoxShadow(
                color: context.shadowColor,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppMeasurements.paddingExtraSmall),
            child: Row(
              children: [
                for (int i = 0; i < tabs.length; i++)
                  Expanded(
                    child: MainNavTab(
                      spec: tabs[i],
                      isActive: navigationShell.currentIndex == i,
                      onTap: () => _onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    // Reload the tab's data every time it's tapped. Because the ViewModels
    // are @lazySingleton, the instance MainLayout resolves from getIt is the
    // same one the tab's screen is bound to via BlocProvider.value.
    _reloadBranch(index);

    // `initialLocation: true` when re-tapping the current tab pops that
    // tab's navigator back to its root.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _reloadBranch(int index) {
    switch (index) {
      case 0:
        getIt<DashboardViewModel>().doIntent(RefreshDashboardEvent());
      case 1:
        final vm = getIt<TransactionsViewModel>();
        vm.doIntent(LoadTransactionsEvent(month: vm.state.selectedMonth));
      case 2:
        getIt<BudgetsViewModel>().doIntent(LoadBudgetsEvent());
      case 3:
        // Settings has no per-screen ViewModel — everything it renders
        // (locale, theme, currency) lives in CoreCubit and reacts live.
        break;
    }
  }
}
