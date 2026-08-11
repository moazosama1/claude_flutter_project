import 'package:initialize_project/core/router/route_names.dart';
import 'package:flutter/material.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const SizedBox());
      default:
        return MaterialPageRoute(builder: (_) => const SizedBox());
    }
  }
}
