import 'dart:math';

import 'package:flutter/material.dart';

class AppResponsive extends StatelessWidget {
  final double? width;
  final Widget child;
  final bool autoCalculateMediaQueryData;

  const AppResponsive({
    super.key,
    required this.width,
    required this.child,
    this.autoCalculateMediaQueryData = true,
  });

  @override
  Widget build(BuildContext context) {
    if (width != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double aspectRatio =
              constraints.maxWidth / constraints.maxHeight;
          final double scaledWidth = width!;
          final double scaledHeight = width! / aspectRatio;

          final Widget childHolder = FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
            child: Container(
              width: width,
              height: scaledHeight,
              alignment: Alignment.center,
              child: child,
            ),
          );

          if (autoCalculateMediaQueryData) {
            final MediaQueryData mediaQueryData = MediaQuery.of(context);

            final bool overrideMediaQueryData =
                (mediaQueryData.size ==
                Size(constraints.maxWidth, constraints.maxHeight));

            final EdgeInsets scaledViewInsets = getScaledViewInsets(
              mediaQueryData: mediaQueryData,
              screenSize: mediaQueryData.size,
              scaledSize: Size(scaledWidth, scaledHeight),
            );
            final EdgeInsets scaledViewPadding = getScaledViewPadding(
              mediaQueryData: mediaQueryData,
              screenSize: mediaQueryData.size,
              scaledSize: Size(scaledWidth, scaledHeight),
            );
            final EdgeInsets scaledPadding = getScaledPadding(
              padding: scaledViewPadding,
              insets: scaledViewInsets,
            );

            if (overrideMediaQueryData) {
              return MediaQuery(
                data: mediaQueryData.copyWith(
                  size: Size(scaledWidth, scaledHeight),
                  viewInsets: scaledViewInsets,
                  viewPadding: scaledViewPadding,
                  padding: scaledPadding,
                ),
                child: childHolder,
              );
            }
          }

          return childHolder;
        },
      );
    }

    return child;
  }

  EdgeInsets getScaledViewInsets({
    required MediaQueryData mediaQueryData,
    required Size screenSize,
    required Size scaledSize,
  }) {
    final double leftInsetFactor =
        mediaQueryData.viewInsets.left / screenSize.width;
    final double topInsetFactor =
        mediaQueryData.viewInsets.top / screenSize.height;
    final double rightInsetFactor =
        mediaQueryData.viewInsets.right / screenSize.width;
    final double bottomInsetFactor =
        mediaQueryData.viewInsets.bottom / screenSize.height;

    final double scaledLeftInset = leftInsetFactor * scaledSize.width;
    final double scaledTopInset = topInsetFactor * scaledSize.height;
    final double scaledRightInset = rightInsetFactor * scaledSize.width;
    final double scaledBottomInset = bottomInsetFactor * scaledSize.height;

    return EdgeInsets.fromLTRB(
      scaledLeftInset,
      scaledTopInset,
      scaledRightInset,
      scaledBottomInset,
    );
  }

  EdgeInsets getScaledViewPadding({
    required MediaQueryData mediaQueryData,
    required Size screenSize,
    required Size scaledSize,
  }) {
    double scaledLeftPadding;
    double scaledTopPadding;
    double scaledRightPadding;
    double scaledBottomPadding;

    final double leftPaddingFactor =
        mediaQueryData.viewPadding.left / screenSize.width;
    final double topPaddingFactor =
        mediaQueryData.viewPadding.top / screenSize.height;
    final double rightPaddingFactor =
        mediaQueryData.viewPadding.right / screenSize.width;
    final double bottomPaddingFactor =
        mediaQueryData.viewPadding.bottom / screenSize.height;

    scaledLeftPadding = leftPaddingFactor * scaledSize.width;
    scaledTopPadding = topPaddingFactor * scaledSize.height;
    scaledRightPadding = rightPaddingFactor * scaledSize.width;
    scaledBottomPadding = bottomPaddingFactor * scaledSize.height;

    return EdgeInsets.fromLTRB(
      scaledLeftPadding,
      scaledTopPadding,
      scaledRightPadding,
      scaledBottomPadding,
    );
  }

  EdgeInsets getScaledPadding({
    required EdgeInsets padding,
    required EdgeInsets insets,
  }) {
    double scaledLeftPadding;
    double scaledTopPadding;
    double scaledRightPadding;
    double scaledBottomPadding;

    scaledLeftPadding = max(0, padding.left - insets.left);
    scaledTopPadding = max(0.0, padding.top - insets.top);
    scaledRightPadding = max(0.0, padding.right - insets.right);
    scaledBottomPadding = max(0.0, padding.bottom - insets.bottom);

    return EdgeInsets.fromLTRB(
      scaledLeftPadding,
      scaledTopPadding,
      scaledRightPadding,
      scaledBottomPadding,
    );
  }
}
