import 'package:flutter/material.dart';
import 'package:initialize_project/core/responsive/app_measurements.dart';

class CustomScreenWrapper extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool applyPadding;
  final bool applySafeArea;
  final Color? backgroundColor;
  const CustomScreenWrapper({
    this.backgroundColor,
    super.key,
    this.appBar,
    required this.body,
    this.applyPadding = true,
    this.applySafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = body;

    if (applyPadding) {
      content = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMeasurements.paddingLarge,
          vertical: AppMeasurements.paddingMedium,
        ),
        child: content,
      );
    }

    if (applySafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      appBar: appBar,
      body: content,
      backgroundColor: backgroundColor,
    );
  }
}
