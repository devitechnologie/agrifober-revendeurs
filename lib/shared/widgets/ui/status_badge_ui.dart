import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';

enum StatusBadgeVariant { success, info, warning, danger, gray, neutral }

class StatusBadgeUI extends StatelessWidget {
  const StatusBadgeUI({
    super.key,
    required this.label,
    this.variant = StatusBadgeVariant.success,
  });

  final String label;
  final StatusBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(variant);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.circle),
      ),
      child: TextUI(
        label,
        style: CustomTextStyle(
          fontSize: AppFontSize.xs,
          color: config.textColor,
          fontWeight: AppFontWeight.medium,
        ),
      ),
    );
  }

  _StatusBadgeConfig _getConfig(StatusBadgeVariant variant) {
    switch (variant) {
      case StatusBadgeVariant.success:
        return _StatusBadgeConfig(
          textColor: AppColors.green,
          backgroundColor: AppColors.success.withValues(alpha: 0.1),
        );
      case StatusBadgeVariant.info:
        return _StatusBadgeConfig(
          textColor: AppColors.info,
          backgroundColor: AppColors.info.withValues(alpha: 0.1),
        );
      case StatusBadgeVariant.warning:
        return _StatusBadgeConfig(
          textColor: AppColors.warning,
          backgroundColor: AppColors.warning.withValues(alpha: 0.1),
        );
      case StatusBadgeVariant.danger:
        return _StatusBadgeConfig(
          textColor: AppColors.danger,
          backgroundColor: AppColors.danger.withValues(alpha: 0.1),
        );
      case StatusBadgeVariant.gray:
        return _StatusBadgeConfig(
          textColor: AppColors.primary,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        );
      case StatusBadgeVariant.neutral:
        return _StatusBadgeConfig(
          textColor: AppColors.black54,
          backgroundColor: AppColors.gray,
        );
    }
  }
}

class _StatusBadgeConfig {
  final Color textColor;
  final Color backgroundColor;

  const _StatusBadgeConfig({
    required this.textColor,
    required this.backgroundColor,
  });
}
