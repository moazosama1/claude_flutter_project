import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/custom_widget/custom_screen_wrapper.dart';
import '../../../core/di/di.dart';
import '../../../core/router/route_names.dart';
import '../view_model/splash_state.dart';
import '../view_model/splash_view_model.dart';
import 'widgets/splash_view_body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashViewModel>(
      create: (_) => getIt<SplashViewModel>(),
      child: BlocListener<SplashViewModel, SplashState>(
        listenWhen: (a, b) => !a.ready && b.ready,
        listener: (context, state) {
          // Route away from splash once ready. Use `go` (not `push`) so the
          // back button on the dashboard doesn't return to the splash.
          context.go(RouteNames.dashboard);
        },
        child: const CustomScreenWrapper(
          applyPadding: false,
          body: SplashViewBody(),
        ),
      ),
    );
  }
}
