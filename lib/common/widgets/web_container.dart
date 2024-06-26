import 'package:flutter/material.dart';
import 'package:tiktok/utils/utils.dart';

class WebContainer extends StatelessWidget {
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;

  const WebContainer({
    Key? key,
    this.child,
    this.padding,
    this.minWidth = 0,
    this.maxWidth = double.infinity,
    this.minHeight = 0,
    this.maxHeight = double.infinity,
    this.alignment = Alignment.topCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment!,
      child: Container(
        padding: padding,
        constraints: BoxConstraints(
          maxHeight: isWebScreen(context) ? maxHeight! : double.infinity,
          maxWidth: isWebScreen(context) ? maxWidth! : double.infinity,
        ),
        child: child,
      ),
    );
  }
}
