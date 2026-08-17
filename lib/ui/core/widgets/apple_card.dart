import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

class AppleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final bool isSelected;
  final bool hasBorder;

  const AppleCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.backgroundColor = AppColors.canvas,
    this.isSelected = false,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = isSelected
        ? Border.all(color: AppColors.primary, width: 2)
        : (hasBorder ? Border.all(color: AppColors.hairline, width: 1) : null);

    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.roundedLg,
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppRadius.roundedLg,
        splashColor: AppColors.primary.withOpacity(0.05),
        highlightColor: Colors.transparent,
        child: card,
      );
    }

    return card;
  }
}
