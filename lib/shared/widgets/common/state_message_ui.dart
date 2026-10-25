import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/widgets/ui/index.dart';

/// Centred icon + title + description, for an empty list ("Aucune vente").
class EmptyStateUI extends StatelessWidget {
  const EmptyStateUI({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
  });

  final String title;
  final String? description;
  final AppIcon? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: icon!(color: AppColors.black54, size: AppFontSize.xxl),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          TextUI(
            title,
            textAlign: CustomTextAlign.center,
            style: CustomTextStyle(
              fontSize: AppFontSize.base,
              fontWeight: AppFontWeight.medium,
              color: AppColors.black,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            TextUI(
              description!,
              textAlign: CustomTextAlign.center,
              style: CustomTextStyle(
                fontSize: AppFontSize.sm,
                color: AppColors.black54,
              ),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppSpacing.base),
            action!,
          ],
        ],
      ),
    );
  }
}

/// A failed load: the failure's (French) message and a "Réessayer" button.
class ErrorStateUI extends StatelessWidget {
  const ErrorStateUI({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyStateUI(
      icon: AppIcons.crossCircleRR,
      title: 'Impossible de charger les données',
      description: ErrorHelper.getErrorMessage(error),
      action: ButtonUI(
        onPressed: onRetry,
        text: 'Réessayer',
        variant: ButtonVariant.outlined,
        width: 160,
        minHeight: 44,
        textSize: AppFontSize.base,
      ),
    );
  }
}
