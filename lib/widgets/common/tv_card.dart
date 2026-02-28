import 'package:flutter/material.dart';
import '../../theme/tv_theme.dart';

/// A styled card container following the TV dark theme.
class TVCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  const TVCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: TVTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? TVTheme.border,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
