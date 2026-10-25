import 'package:flutter/cupertino.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';

enum ChipVariant { primary }

class ChipUI extends StatelessWidget {
  const ChipUI({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ChipVariant.primary,
    this.icon,
    this.textSize = AppFontSize.sm,
    this.iconSize = AppFontSize.base,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.base,
      vertical: AppSpacing.xs,
    ),
    this.borderRadius = AppRadius.circle,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.valid = true,
    this.trailing,
  });

  final String text;
  final VoidCallback onPressed;
  final ChipVariant variant;
  final AppIcon? icon;
  final double textSize;
  final double iconSize;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool valid;
  final Widget? trailing;

  Color get _resolvedTextColor {
    if (!valid) return AppColors.black54;
    switch (variant) {
      case ChipVariant.primary:
        return textColor ?? AppColors.primary;
    }
  }

  Color get _resolvedBorderColor {
    if (!valid) return AppColors.gray500;
    switch (variant) {
      case ChipVariant.primary:
        return borderColor ?? AppColors.gray;
    }
  }

  Color? get _resolvedBackgroundColor {
    switch (variant) {
      case ChipVariant.primary:
        return backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: _resolvedBorderColor, width: 0.8),
      ),
      child: CupertinoButton(
        onPressed: valid ? onPressed : null,
        color: _resolvedBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        pressedOpacity: 0.6,
        padding: padding,
        minimumSize: Size.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!(color: _resolvedTextColor, size: iconSize),
              const SizedBox(width: AppSpacing.xs),
            ],
            TextUI(
              text,
              style: CustomTextStyle(
                fontSize: textSize,
                fontWeight: AppFontWeight.medium,
                color: _resolvedTextColor,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.xs),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
