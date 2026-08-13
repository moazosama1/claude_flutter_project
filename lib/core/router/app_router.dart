import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initialize_project/core/core_cubit/core_cubit.dart';
import 'package:initialize_project/core/di/di.dart';
import 'package:initialize_project/core/router/go_router_refresh_stream.dart';
import 'package:initialize_project/core/router/route_names.dart';
import 'package:initialize_project/presentation/budgets/view/budgets_screen.dart';
import 'package:initialize_project/presentation/categories/view/categories_screen.dart';
import 'package:initialize_project/presentation/commitments/view/commitments_screen.dart';
import 'package:initialize_project/presentation/dashboard/view/dashboard_screen.dart';
import 'package:initialize_project/presentation/main_layout/view/main_layout.dart';
import 'package:initialize_project/presentation/settings/view/settings_screen.dart';
import 'package:initialize_project/presentation/splash/view/splash_screen.dart';
import 'package:initialize_project/presentation/transactions/view/transactions_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _dashboardNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'dashboardTab');
  static final GlobalKey<NavigatorState> _transactionsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'transactionsTab');
  static final GlobalKey<NavigatorState> _budgetsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'budgetsTab');
  static final GlobalKey<NavigatorState> _settingsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'settingsTab');

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(getIt<CoreCubit>().stream),
    routes: [
      // Outside the shell: splash sits on its own so the bottom nav doesn't
      // render underneath the loading screen.
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const _PlaceholderHome(),
      ),
      // Categories management sits OUTSIDE the shell so the bottom nav pill
      // doesn't render underneath — it's a full-screen management page with
      // an AppBar + back button.
      GoRoute(
        path: RouteNames.categories,
        name: RouteNames.categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      // Commitments: also outside the shell — full-screen management page.
      GoRoute(
        path: RouteNames.commitments,
        name: RouteNames.commitments,
        builder: (context, state) => const CommitmentsScreen(),
      ),

      // Main shell — everything below shares the persistent bottom nav.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainLayout(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.dashboard,
                name: RouteNames.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _transactionsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.transactions,
                name: RouteNames.transactions,
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _budgetsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.budgets,
                name: RouteNames.budgets,
                builder: (context, state) => const BudgetsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.settings,
                name: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Kept as a fallback landing page (still reachable via /home). Not used by
// the shell — the app's real entry point is Splash → Dashboard.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Placeholder home.'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                FilledButton(
                  onPressed: () => context.go(RouteNames.dashboard),
                  child: const Text('Dashboard'),
                ),
                FilledButton(
                  onPressed: () => context.go(RouteNames.transactions),
                  child: const Text('Transactions'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
