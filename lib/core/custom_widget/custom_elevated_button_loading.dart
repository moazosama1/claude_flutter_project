import 'package:flutter/material.dart';
import 'package:initialize_project/core/custom_widget/custom_loading_indicator.dart';
import 'package:initialize_project/core/responsive/app_measurements.dart';
import 'package:initialize_project/generated/l10n.dart';

class CustomElevatedButtonLoading extends StatelessWidget {
  const CustomElevatedButtonLoading({
    super.key,
    this.heightButton,
    this.widthButton,
    this.borderButton,
    this.textButton,
    this.textStyleButton,
    this.colorButton,
    this.onPressed,
    this.loadingColor,
    this.elevation,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
  });

  final bool isExpanded;
  final bool? isLoading;
  final double? heightButton, widthButton, borderButton, elevation;
  final String? textButton;
  final TextStyle? textStyleButton;
  final Color? colorButton, loadingColor;
  final Widget? icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context);
    return SizedBox(
      height: heightButton ?? AppMeasurements.buttonHeight,
      width: isExpanded ? double.infinity : widthButton,
      child: ElevatedButton(
        onPressed: (isLoading == true) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton ?? theme.colorScheme.primary,
          disabledBackgroundColor: colorButton ?? theme.colorScheme.primary,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderButton ?? AppMeasurements.paddingMedium,
            ),
          ),
        ),
        child: isLoading == true
            ? CustomLoadingIndicator(
                color: loadingColor ?? theme.colorScheme.onSecondary,
                size: AppMeasurements.buttonHeight * 0.6,
              )
            : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      textButton ?? local.done,
                      style: textStyleButton,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            : Text(
                textButton ?? local.done,
                style: textStyleButton,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}
