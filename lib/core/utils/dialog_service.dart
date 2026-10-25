import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/shared.dart';

class DialogService {
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required ValueNotifier<bool> isLoadingNotifier,
    String? cancelText,
    required Function({required VoidCallback onClose}) onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder<bool>(
          valueListenable: isLoadingNotifier,
          builder: (context, isLoading, child) {
            return PopScope(
              canPop: !isLoading,
              child: AlertDialog(
                backgroundColor: AppColors.white,
                title: TextUI(
                  title,
                  style: CustomTextStyle(
                    fontSize: AppFontSize.xl,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                content: TextUI(
                  content,
                  style: CustomTextStyle(
                    fontSize: AppFontSize.base,
                    fontWeight: AppFontWeight.regular,
                    color: AppColors.black87,
                  ),
                ),
                actions: [
                  Column(
                    children: [
                      ButtonUI(
                        variant: ButtonVariant.primary,
                        isLoading: isLoading,
                        onPressed: () {
                          onConfirm(onClose: () => Navigator.of(context).pop());
                        },
                        text: confirmText,
                      ),
                      if (cancelText != null) ...[
                        SizedBox(height: AppSpacing.sm),
                        ButtonUI(
                          variant: ButtonVariant.outlined,
                          onPressed: () {
                            if (!isLoading) Navigator.of(context).pop();
                          },
                          text: cancelText,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
