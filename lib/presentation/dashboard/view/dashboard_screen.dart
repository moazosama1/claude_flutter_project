import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/custom_widget/custom_screen_wrapper.dart';
import '../../../core/di/di.dart';
import '../view_model/dashboard_view_model.dart';
import 'widgets/dashboard_view_body.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // `.value` (not `create`) — the ViewModel is a lazySingleton so
    // BlocProvider must NOT dispose it when the screen is popped.
    return BlocProvider<DashboardViewModel>.value(
      value: getIt<DashboardViewModel>(),
      child: const CustomScreenWrapper(body: DashboardViewBody()),
    );
  }
}
