import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/gen/fonts.gen.dart';

enum ButtonVariant { primary, outlined, gradient }

class ButtonUI extends StatelessWidget {
  const ButtonUI({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderRadius = AppRadius.tiny,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppSpacing.base,
      horizontal: AppSpacing.base,
    ),
    this.variant = ButtonVariant.primary,
    this.valid = true,
    this.width = double.infinity,
    this.backgroundColor,
    this.textSize = AppFontSize.lg,
    this.icon,
    this.elevation = 0,
    this.setTextColor,
    this.iconSize = AppFontSize.base,
    this.prefix,
    this.minHeight = 54,
    this.maxHeight = double.infinity,
    this.trailingIcon,
    this.isLoading = false,
  });

  final void Function() onPressed;
  final String text;
  final double borderRadius;
  final EdgeInsets padding;
  final ButtonVariant variant;
  final bool valid;
  final double width;
  final Color? backgroundColor;
  final double textSize;
  final AppIcon? icon;
  final double elevation;
  final Color? setTextColor;
  final double iconSize;
  final Widget? prefix;
  final double minHeight;
  final double maxHeight;
  final Widget? trailingIcon;
  final bool isLoading;

  Color get color {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.outlined:
        return Colors.white;
      // The gradient is painted by the wrapping decoration instead.
      case ButtonVariant.gradient:
        return Colors.transparent;
    }
  }

  Color get textColor {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.white;
      case ButtonVariant.outlined:
        return AppColors.primary;
      case ButtonVariant.gradient:
        return AppColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        // min height to avoid the button from shrinking
        constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
        decoration: BoxDecoration(
          border: variant == ButtonVariant.outlined
              ? Border.all(color: AppColors.gray500, width: 1)
              : null,
          // Disabled buttons keep the flat accent fill, so only tint when valid.
          gradient: variant == ButtonVariant.gradient && valid
              ? AppColors.primaryGradient
              : null,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            elevation > 0
                ? BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: elevation,
                    spreadRadius: 1,
                    offset: const Offset(-0.7, 0.7),
                  )
                : const BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Stack(
          children: [
            CupertinoButton(
              onPressed: () => (valid && !isLoading) ? onPressed() : null,
              color: valid ? backgroundColor ?? color : AppColors.accent,
              borderRadius: BorderRadius.circular(borderRadius),
              pressedOpacity: 0.8,
              padding: padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    SizedBox(
                      width: textSize,
                      height: textSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          valid ? setTextColor ?? textColor : AppColors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.base),
                  ],
                  if (prefix != null) ...[
                    prefix!,
                    const SizedBox(width: AppSpacing.base),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: textSize,
                      fontWeight: AppFontWeight.medium,
                      color: valid
                          ? setTextColor ?? textColor
                          : AppColors.black54,
                      fontFamily: FontFamily.roobertPRO,
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    icon!(
                      color: valid
                          ? setTextColor ?? textColor
                          : AppColors.black54,
                      size: iconSize,
                    ),
                  ],
                ],
              ),
            ),
            if (trailingIcon != null) ...[
              Positioned(
                right: AppSpacing.base,
                bottom: 0,
                top: 0,
                child: Center(child: IgnorePointer(child: trailingIcon!)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
