import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key, this.color, this.size = 50.0});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: color ?? Theme.of(context).colorScheme.primary,
      size: size,
    );
  }
}
