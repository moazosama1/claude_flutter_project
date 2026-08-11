import 'package:flutter/material.dart';
import 'package:initialize_project/core/constants/app_colors.dart';
import 'package:initialize_project/core/extensions/theme_extension.dart';
import 'package:initialize_project/core/responsive/app_measurements.dart';

class CustomStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accentColor;
  final IconData? icon;
  final String? subtitle;
  final double? minWidth;
  final double? height;
  final bool verticalLayout;

  const CustomStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.accentColor,
    this.icon,
    this.subtitle,
    this.minWidth,
    this.height,
    this.verticalLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth ?? AppMeasurements.quickPickHeight,
      ),
      height: height,
      padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.tabSurface,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.15),
            accentColor.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(AppMeasurements.radiusLarge),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: verticalLayout
          ? _buildVerticalLayout(context)
          : _buildHorizontalLayout(context),
    );
  }

  Widget _buildVerticalLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(
                    AppMeasurements.radiusSmall,
                  ),
                ),
                child: Icon(icon, size: 22, color: accentColor),
              ),
              const SizedBox(width: AppMeasurements.paddingSmall),
            ],
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.bodyMedium?.copyWith(
                  color: context.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        if (height != null)
          const Spacer()
        else
          const SizedBox(height: AppMeasurements.paddingMedium),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            value,
            style: context.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.onSurface,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    final String badgeText = subtitle ?? title;
    final String? outsideText = subtitle != null ? title : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppMeasurements.paddingSmall,
                vertical: AppMeasurements.paddingExtraSmall,
              ),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(
                  AppMeasurements.paddingExtraSmall,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 14, color: accentColor),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    badgeText,
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
            if (outsideText != null) ...[
              const SizedBox(width: AppMeasurements.paddingExtraSmall),
              Flexible(
                child: Text(
                  outsideText,
                  style: context.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.onSurface.withValues(alpha: 0.55),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppMeasurements.paddingMedium),
        Text(
          value,
          style: context.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.onSurface,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
