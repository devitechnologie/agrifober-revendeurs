import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/index.dart';

/// Bordered white card with an optional title row — the building block of the
/// account screens (Profil, Statistiques, Crédit…), mirroring the web app's
/// revendeur page.
class SectionCardUI extends StatelessWidget {
  const SectionCardUI({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.base),
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.tiny),
        border: Border.all(color: AppColors.gray),
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            // Cards whose rows run edge to edge (top-only padding) still
            // align their title with the rows' own 16 px inset.
            Padding(
              padding: EdgeInsets.only(
                left: padding.left > 0 ? 0 : AppSpacing.base,
                right: padding.right > 0 ? 0 : AppSpacing.base,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextUI(
                      title!,
                      style: CustomTextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: AppFontWeight.medium,
                        color: AppColors.black54,
                      ),
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          child,
        ],
      ),
    );
  }
}

/// `label ……… value` row inside a [SectionCardUI].
class InfoRowUI extends StatelessWidget {
  const InfoRowUI({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.black,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      // Both sides loose + spaceBetween: the value hugs the right edge whatever
      // its length, and a long label or value still wraps instead of
      // overflowing.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: TextUI(
              label,
              style: CustomTextStyle(
                fontSize: AppFontSize.sm,
                color: AppColors.black54,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: TextUI(
              value,
              textAlign: CustomTextAlign.right,
              style: CustomTextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: bold ? AppFontWeight.bold : AppFontWeight.medium,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tappable row of a document list (vente, bon, facture, commande): title +
/// subtitle on the left, amount + badge on the right.
class DocumentTileUI extends StatelessWidget {
  const DocumentTileUI({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.badge,
    this.footnote,
    this.footnoteColor = AppColors.black54,
    this.onTap,
    this.icon,
  });

  final String title;
  final String subtitle;
  final String amount;

  /// Leading icon in a light green circle; tells document kinds apart.
  final AppIcon? icon;
  final Widget? badge;
  final String? footnote;
  final Color footnoteColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.black.withValues(alpha: 0.06),
        highlightColor: AppColors.black.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.base),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: icon!(
                      color: AppColors.primary,
                      size: AppFontSize.base,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              // The divider starts after the icon, like native lists.
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    right: AppSpacing.base,
                    top: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.gray)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextUI(
                              title,
                              maxLines: 1,
                              style: CustomTextStyle(
                                fontSize: AppFontSize.base,
                                fontWeight: AppFontWeight.medium,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            TextUI(
                              subtitle,
                              maxLines: 1,
                              style: CustomTextStyle(
                                fontSize: AppFontSize.xs,
                                color: AppColors.black54,
                              ),
                            ),
                            if (footnote != null) ...[
                              const SizedBox(height: 2),
                              TextUI(
                                footnote!,
                                maxLines: 1,
                                style: CustomTextStyle(
                                  fontSize: AppFontSize.xs,
                                  fontWeight: AppFontWeight.medium,
                                  color: footnoteColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextUI(
                            amount,
                            style: CustomTextStyle(
                              fontSize: AppFontSize.sm,
                              fontWeight: AppFontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(height: AppSpacing.xxs),
                            badge!,
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
