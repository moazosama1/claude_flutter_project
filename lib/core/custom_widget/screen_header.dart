import 'package:flutter/material.dart';
import 'package:initialize_project/core/extensions/theme_extension.dart';
import 'package:initialize_project/core/responsive/app_measurements.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppMeasurements.paddingSmall),
        Text(
          subtitle,
          style: context.labelMedium?.copyWith(
            color: context.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
