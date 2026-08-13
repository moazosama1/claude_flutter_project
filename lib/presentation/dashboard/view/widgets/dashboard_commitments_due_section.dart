import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/router/route_names.dart';
import '../../../commitments/view_model/commitments_state.dart';
import '../../../commitments/view_model/commitments_view_model.dart';

/// Compact strip on the dashboard summarizing due-this-week commitments.
/// Hides entirely when the user has no commitments yet — no nagging before
/// the feature is in use.
class DashboardCommitmentsDueSection extends StatelessWidget {
  const DashboardCommitmentsDueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommitmentsViewModel>.value(
      value: getIt<CommitmentsViewModel>(),
      child: BlocBuilder<CommitmentsViewModel, CommitmentsState>(
        builder: (context, state) {
          final commitments = state.commitments.data ?? const [];
          if (commitments.isEmpty) return const SizedBox.shrink();

          final due = state.dueThisWeekCount;
          final Color accent;
          final IconData icon;
          final String message;
          if (due > 0) {
            accent = context.warningColor;
            icon = Icons.event_available_rounded;
            message = context.l10n.commitmentsDueThisWeek(due);
          } else {
            accent = context.successColor;
            icon = Icons.check_circle_outline_rounded;
            message = context.l10n.commitmentsAllCaughtUp;
          }

          return Padding(
            padding: const EdgeInsets.only(
              bottom: AppMeasurements.paddingLarge,
            ),
            child: Material(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppMeasurements.radiusLarge),
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  AppMeasurements.radiusLarge,
                ),
                onTap: () => context.push(RouteNames.commitments),
                child: Padding(
                  padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
                  child: Row(
                    children: [
                      Icon(icon, color: accent),
                      const SizedBox(width: AppMeasurements.paddingMedium),
                      Expanded(
                        child: Text(
                          message,
                          style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: due > 0 ? accent : context.onSurface,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.onSurface.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
