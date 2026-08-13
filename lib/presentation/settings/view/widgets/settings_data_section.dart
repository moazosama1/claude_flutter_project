import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/custom_widget/custom_dialog.dart';
import '../../../../core/custom_widget/custom_elevated_button_loading.dart';
import '../../../../core/custom_widget/custom_toastification.dart';
import '../../../../core/di/di.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../budgets/view_model/budgets_events.dart';
import '../../../budgets/view_model/budgets_view_model.dart';
import '../../../dashboard/view_model/dashboard_events.dart';
import '../../../dashboard/view_model/dashboard_view_model.dart';
import '../../../transactions/view_model/transactions_events.dart';
import '../../../transactions/view_model/transactions_view_model.dart';
import '../../view_model/backup_cubit.dart';
import '../../view_model/backup_events.dart';
import '../../view_model/backup_state.dart';
import 'settings_tile.dart';

/// Settings section giving the user export + import buttons for a manual
/// offline backup. Uses its own [BackupCubit] provided at this widget's root
/// so the rest of Settings doesn't need to know about backup state.
class SettingsDataSection extends StatelessWidget {
  const SettingsDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BackupCubit>(
      create: (_) => getIt<BackupCubit>(),
      child: MultiBlocListener(
        listeners: [
          // Export: success/error toasts, no side effects on other cubits.
          BlocListener<BackupCubit, BackupState>(
            listenWhen: (a, b) => a.export != b.export && !b.export.isLoading,
            listener: (context, state) {
              if (state.export.errorMessage != null) {
                customToastification(
                  context,
                  ToastificationType.error,
                  state.export.errorMessage,
                );
              } else {
                customToastification(
                  context,
                  ToastificationType.success,
                  context.l10n.exportSuccess,
                );
              }
            },
          ),
          // Import: on success, refresh every other singleton so the whole
          // app reflects the restored data instantly; then toast.
          BlocListener<BackupCubit, BackupState>(
            listenWhen: (a, b) => a.import != b.import && !b.import.isLoading,
            listener: (context, state) {
              if (state.import.errorMessage != null) {
                customToastification(
                  context,
                  ToastificationType.error,
                  state.import.errorMessage,
                );
                return;
              }
              _refreshSingletons();
              customToastification(
                context,
                ToastificationType.success,
                context.l10n.importSuccess,
              );
            },
          ),
        ],
        child: SettingsGroup(
          title: context.l10n.dataTitle,
          icon: Icons.folder_zip_outlined,
          children: const [
            _ExportRow(),
            Divider(height: 1),
            _ImportRow(),
          ],
        ),
      ),
    );
  }

  void _refreshSingletons() {
    final txnVm = getIt<TransactionsViewModel>();
    txnVm.doIntent(LoadTransactionsEvent(month: txnVm.state.selectedMonth));
    getIt<DashboardViewModel>().doIntent(RefreshDashboardEvent());
    getIt<BudgetsViewModel>().doIntent(LoadBudgetsEvent());
  }
}

class _ExportRow extends StatelessWidget {
  const _ExportRow();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BackupCubit, BackupState, bool>(
      selector: (state) => state.export.isLoading,
      builder: (context, isLoading) {
        return Padding(
          padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.exportData,
                      style: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.exportDataDesc,
                      style: context.labelSmall?.copyWith(
                        color: context.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppMeasurements.paddingMedium),
              CustomElevatedButtonLoading(
                isLoading: isLoading,
                onPressed: () => context
                    .read<BackupCubit>()
                    .doIntent(ExportBackupEvent()),
                icon: const Icon(Icons.ios_share_rounded, size: 18),
                textButton: context.l10n.exportData,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ImportRow extends StatelessWidget {
  const _ImportRow();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BackupCubit, BackupState, bool>(
      selector: (state) => state.import.isLoading,
      builder: (context, isLoading) {
        return Padding(
          padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.importData,
                      style: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.importDataDesc,
                      style: context.labelSmall?.copyWith(
                        color: context.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppMeasurements.paddingMedium),
              CustomElevatedButtonLoading(
                isLoading: isLoading,
                onPressed: () => _pickAndImport(context),
                icon: const Icon(Icons.file_upload_outlined, size: 18),
                textButton: context.l10n.restore,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAndImport(BuildContext context) async {
    final cubit = context.read<BackupCubit>();

    // file_picker 11+ exposes pickFiles as a static on FilePicker.
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (picked == null || picked.files.isEmpty) return;
    final path = picked.files.single.path;
    if (path == null) return;

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => CustomDialog(
        showCloseButton: false,
        header: Text(
          dialogCtx.l10n.importData,
          style: dialogCtx.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dialogCtx.l10n.importWarning,
              style: dialogCtx.bodyMedium,
            ),
            const SizedBox(height: AppMeasurements.paddingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(false),
                  child: Text(dialogCtx.l10n.cancel),
                ),
                const SizedBox(width: AppMeasurements.paddingSmall),
                CustomElevatedButtonLoading(
                  isLoading: false,
                  onPressed: () => Navigator.of(dialogCtx).pop(true),
                  textButton: dialogCtx.l10n.restore,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      cubit.doIntent(ImportBackupEvent(path));
    }
  }
}
