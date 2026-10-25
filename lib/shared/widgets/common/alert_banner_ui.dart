import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/shared/widgets/ui/index.dart';
import 'package:agrifober_resellers/config/config.dart';

enum AlertType { danger, warning, success, info }

class AlertBannerUI extends StatelessWidget {
  const AlertBannerUI({
    super.key,
    required this.message,
    this.type = AlertType.danger,
    this.onDismiss,
    this.show = true,
    this.spacingAbove = 0,
    this.spacingBelow = 0,
    this.textSize = AppFontSize.base,
    this.iconSize = AppFontSize.xl,
  });

  final String message;
  final AlertType type;
  final VoidCallback? onDismiss;
  final bool show;
  final double spacingAbove;
  final double spacingBelow;
  final double textSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    final config = _getAlertConfig(type);

    return Column(
      children: [
        if (spacingAbove > 0) SizedBox(height: spacingAbove),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: config.backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.base),
          ),
          child: Row(
            children: [
              config.icon(color: config.iconColor, size: iconSize),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2),
                    TextUI(
                      message,
                      style: CustomTextStyle(
                        color: config.textColor,
                        fontSize: textSize,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null) ...[
                const SizedBox(width: AppSpacing.sm),
                GestureDetector(
                  onTap: onDismiss,
                  child: AppIcons.closeRR(color: config.iconColor, size: 18),
                ),
              ],
            ],
          ),
        ),
        if (spacingBelow > 0) SizedBox(height: spacingBelow),
      ],
    );
  }

  _AlertConfig _getAlertConfig(AlertType type) {
    switch (type) {
      case AlertType.danger:
        return _AlertConfig(
          backgroundColor: AppColors.danger.withValues(alpha: 0.1),
          iconColor: AppColors.danger,
          textColor: AppColors.danger,
          icon: AppIcons.squaredExamIconRR,
        );
      case AlertType.warning:
        return _AlertConfig(
          backgroundColor: AppColors.warning.withValues(alpha: 0.1),
          iconColor: AppColors.warning,
          textColor: AppColors.warning,
          icon: AppIcons.squaredExamIconRR,
        );
      case AlertType.success:
        return _AlertConfig(
          backgroundColor: AppColors.success.withValues(alpha: 0.1),
          iconColor: AppColors.success,
          textColor: AppColors.success,
          icon: AppIcons.checkRR,
        );
      case AlertType.info:
        return _AlertConfig(
          backgroundColor: AppColors.info.withValues(alpha: 0.1),
          iconColor: AppColors.info,
          textColor: AppColors.info,
          icon: AppIcons.questionIconRR,
        );
    }
  }
}

class _AlertConfig {
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final AppIcon icon;

  const _AlertConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });
}
