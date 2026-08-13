import 'package:flutter/material.dart';

import '../../../core/extensions/theme_extension.dart';
import '../../../core/responsive/app_measurements.dart';

/// Data class describing one tab inside the [MainLayout] bottom nav.
class MainNavTabSpec {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const MainNavTabSpec({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// A single tab in the floating pill-style bottom nav bar. Active state
/// morphs the background to primary and reveals the label; inactive shows
/// icon only. Two animations run in parallel: color/shape via
/// [AnimatedContainer], label reveal via [AnimatedSize].
class MainNavTab extends StatelessWidget {
  final MainNavTabSpec spec;
  final bool isActive;
  final VoidCallback onTap;

  const MainNavTab({
    super.key,
    required this.spec,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppMeasurements.radiusLarge);
    final inactiveColor = context.onSurface.withValues(alpha: 0.6);

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: AppMeasurements.bottomNavBarHeight,
          decoration: BoxDecoration(
            color: isActive ? context.primaryColor : Colors.transparent,
            borderRadius: radius,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppMeasurements.paddingSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? spec.activeIcon : spec.icon,
                size: AppMeasurements.iconMedium,
                color: isActive ? context.onPrimary : inactiveColor,
              ),
              // Flexible so the label shrinks to the space left after the
              // icon and ellipsizes instead of overflowing — important once
              // there are 4 tabs and long (e.g. Arabic) labels.
              Flexible(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: isActive
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: AppMeasurements.paddingExtraSmall,
                          ),
                          child: Text(
                            spec.label,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: context.labelSmall?.copyWith(
                              color: context.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
