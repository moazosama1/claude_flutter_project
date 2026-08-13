import 'package:flutter/material.dart';

import '../../../../core/custom_widget/custom_loading_indicator.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';

class SplashViewBody extends StatelessWidget {
  const SplashViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppMeasurements.splashLogoSize,
            height: AppMeasurements.splashLogoSize,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: AppMeasurements.splashLogoSize * 0.5,
              color: context.primaryColor,
            ),
          ),
          const SizedBox(height: AppMeasurements.paddingLarge),
          Text(
            context.l10n.appName,
            style: context.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
          const SizedBox(height: AppMeasurements.paddingLarge),
          const CustomLoadingIndicator(size: 32),
        ],
      ),
    );
  }
}
