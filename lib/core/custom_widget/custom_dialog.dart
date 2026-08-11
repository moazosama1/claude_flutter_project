import 'package:flutter/material.dart';
import 'package:initialize_project/core/responsive/app_measurements.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  final Widget? header;
  final bool showCloseButton;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CustomDialog({
    super.key,
    required this.child,
    this.header,
    this.showCloseButton = true,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
      ),
      child: Container(
        width: width ?? 400,
        padding: padding ?? const EdgeInsets.all(AppMeasurements.paddingLarge),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null) ...[
                  header!,
                  const SizedBox(height: AppMeasurements.paddingMedium),
                ],
                Flexible(child: child),
              ],
            ),
            if (showCloseButton)
              Positioned.directional(
                textDirection: Directionality.of(context),
                top: 0,
                start: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      AppMeasurements.radiusMedium,
                    ),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
