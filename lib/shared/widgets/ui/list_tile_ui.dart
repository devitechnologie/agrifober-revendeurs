import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/config/config.dart';

class ListTileUI extends StatelessWidget {
  const ListTileUI({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.onTap,
    this.divider = true,
    this.accordion,
    this.isExpanded = false,
    this.onToggle,
    this.color = AppColors.black,
  });

  final String title;
  final AppIcon? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool divider;
  final Widget? accordion;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (accordion != null) {
      return _buildAccordionLayout();
    }
    return _buildSimpleLayout();
  }

  Widget _buildAccordionLayout() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onToggle?.call();
          onTap?.call();
        },
        splashColor: AppColors.black.withValues(alpha: 0.06),
        highlightColor: AppColors.black.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Column(
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(AppSpacing.xxs),
                      child: icon!(color: color, size: AppFontSize.base),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: divider && !isExpanded
                            ? Border(
                                bottom: BorderSide(color: AppColors.gray500),
                              )
                            : null,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.base,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextUI(
                            title,
                            style: CustomTextStyle(
                              fontSize: AppFontSize.base,
                              color: color,
                              fontWeight: AppFontWeight.medium,
                            ),
                          ),
                          trailing ??
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                child: AppIcons.arrowDownIconRR(
                                  color: color,
                                  size: AppFontSize.lg,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                clipBehavior: Clip.hardEdge,
                child: isExpanded
                    ? Row(
                        children: [
                          if (icon != null) ...[
                            const SizedBox(width: 30),
                            const SizedBox(width: AppSpacing.sm),
                          ],
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: divider
                                    ? Border(
                                        bottom: BorderSide(
                                          color: AppColors.gray500,
                                        ),
                                      )
                                    : null,
                              ),
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.base,
                              ),
                              child: accordion!,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleLayout() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap?.call(),
        splashColor: AppColors.black.withValues(alpha: 0.06),
        highlightColor: AppColors.black.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(AppSpacing.xxs),
                  child: icon!(color: color, size: AppFontSize.base),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: divider
                        ? Border(bottom: BorderSide(color: AppColors.gray500))
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.base,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextUI(
                          title,
                          maxLines: 1,
                          style: CustomTextStyle(
                            fontSize: AppFontSize.base,
                            color: color,
                            fontWeight: AppFontWeight.medium,
                          ),
                        ),
                      ),
                      trailing ??
                          AppIcons.angleSmallRightIconRR(
                            color: color,
                            size: AppFontSize.lg,
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
