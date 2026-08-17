import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class ApplePillButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isSecondary;
  final bool isDestructive;
  final EdgeInsetsGeometry padding;

  const ApplePillButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.isDestructive = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  @override
  State<ApplePillButton> createState() => _ApplePillButtonState();
}

class _ApplePillButtonState extends State<ApplePillButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    Border? border;

    if (widget.isDestructive) {
      bg = const Color(0xFFFF3B30).withOpacity(0.12);
      textColor = const Color(0xFFFF3B30);
    } else if (widget.isSecondary) {
      bg = AppColors.canvas;
      textColor = AppColors.ink;
      border = Border.all(color: AppColors.hairline, width: 1);
    } else {
      bg = AppColors.primary;
      textColor = Colors.white;
    }

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppRadius.roundedPill,
            border: border,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: textColor),
                const SizedBox(width: 6),
              ],
              Text(
                widget.text,
                style: AppTypography.buttonText.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
