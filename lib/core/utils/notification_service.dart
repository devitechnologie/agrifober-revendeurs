import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/config/config.dart';

class NotificationService {
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context,
      message: message,
      type: AlertType.danger,
      duration: duration,
    );
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context,
      message: message,
      type: AlertType.success,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    _showSnackBar(
      context,
      message: message,
      type: AlertType.warning,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context,
      message: message,
      type: AlertType.info,
      duration: duration,
    );
  }

  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required AlertType type,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.all(AppSpacing.base),
        duration: duration,
        content: Container(
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(AppRadius.base),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray600.withValues(alpha: 0.3),
                blurRadius: 10.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: AlertBannerUI(message: message, type: type),
        ),
      ),
    );
  }
}
