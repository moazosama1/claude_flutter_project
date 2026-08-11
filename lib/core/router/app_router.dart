import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:initialize_project/core/core_cubit/core_cubit.dart';
import 'package:initialize_project/core/di/di.dart';
import 'package:initialize_project/core/router/go_router_refresh_stream.dart';
import 'package:initialize_project/core/router/route_names.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(getIt<CoreCubit>().stream),
    routes: [
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (context, state) => const _PlaceholderHome(),
      ),
      // TODO: register the transactions feature routes here once implemented in Phase B.
    ],
  );
}

// Temporary landing page until the finance tracker feature lands.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Core sync complete. Finance tracker coming next.'),
      ),
    );
  }
}
