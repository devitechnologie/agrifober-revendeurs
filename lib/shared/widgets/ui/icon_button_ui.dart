import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';

class IconButtonUI extends StatelessWidget {
  const IconButtonUI({
    super.key,
    this.onPressed,
    required this.icon,
    this.iconSize = AppFontSize.lg + 1,
    this.color = AppColors.black,
    this.padding = const EdgeInsets.all(AppSpacing.sm - 1),
    this.backgroundColor = AppColors.accent,
    this.haveBorder = false,
    this.borderRadius = 999,
    this.borderColor = AppColors.gray500,
    this.haveSplash = true,
  });

  final VoidCallback? onPressed;
  final AppIcon icon;
  final double iconSize;
  final Color color;
  final Color backgroundColor;
  final EdgeInsets padding;
  final bool haveBorder;
  final double borderRadius;
  final Color borderColor;
  final bool haveSplash;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon(color: color, size: iconSize),
      style: ButtonStyle(
        splashFactory: haveSplash
            ? InkRipple.splashFactory
            : NoSplash.splashFactory,
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        padding: WidgetStateProperty.all(padding),
        minimumSize: WidgetStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        side: haveBorder
            ? WidgetStateProperty.all(BorderSide(color: borderColor, width: 1))
            : WidgetStateProperty.all(BorderSide.none),
      ),
      padding: padding,
      iconSize: iconSize,
      color: color,
    );
  }
}
