import 'package:flutter/cupertino.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';

class FloatingButtonUI extends StatelessWidget {
  const FloatingButtonUI({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.size = 56.0,
    this.iconSize = AppFontSize.xl,
    this.backgroundColor,
    this.iconColor,
  });

  final VoidCallback onPressed;
  final String? label;
  final AppIcon? icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final resolvedIcon = icon ?? AppIcons.plusRR;

    if (label != null) {
      return _buildWithLabel(resolvedIcon);
    }

    return _buildWithoutLabel(resolvedIcon);
  }

  Widget _buildWithLabel(AppIcon resolvedIcon) {
    return SizedBox(
      height: size / 1.1,
      child: IntrinsicWidth(
        child: CupertinoButton(
          onPressed: onPressed,
          color: backgroundColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.circle),
          pressedOpacity: 0.8,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Row(
            children: [
              resolvedIcon(color: iconColor ?? AppColors.white, size: iconSize),
              const SizedBox(width: AppSpacing.sm),
              TextUI(
                label!,
                maxLines: 1,
                style: CustomTextStyle(
                  color: iconColor ?? AppColors.white,
                  fontSize: AppFontSize.base,
                  fontWeight: AppFontWeight.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWithoutLabel(AppIcon resolvedIcon) {
    return SizedBox(
      width: size,
      height: size,
      child: CupertinoButton(
        onPressed: onPressed,
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.circle),
        pressedOpacity: 0.8,
        padding: EdgeInsets.zero,
        child: resolvedIcon(
          color: iconColor ?? AppColors.white,
          size: iconSize,
        ),
      ),
    );
  }
}
