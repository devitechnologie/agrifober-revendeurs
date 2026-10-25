import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/shared.dart';

class AppBarHeader extends StatelessWidget {
  const AppBarHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          TextUI(
            title,
            style: CustomTextStyle(
              fontSize: AppFontSize.xl,
              fontWeight: AppFontWeight.bold,
              color: AppColors.black,
            ),
          ),
          if (action != null) ...[const Spacer(), action!],
        ],
      ),
    );
  }
}

class ScreenHeader extends StatefulWidget {
  const ScreenHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  State<ScreenHeader> createState() => _ScreenHeaderState();
}

class _ScreenHeaderState extends State<ScreenHeader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUI(
            widget.title,
            style: CustomTextStyle(
              fontSize: AppFontSize.xxl - 2,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            TextUI(
              widget.subtitle!,
              style: CustomTextStyle(
                fontSize: AppFontSize.base,
                fontWeight: AppFontWeight.light,
                color: AppColors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SectionHeader extends StatefulWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.padding = EdgeInsets.zero,
    this.fontWeight = AppFontWeight.bold,
  });

  final String title;
  final String? subtitle;
  final EdgeInsets padding;
  final FontWeight fontWeight;

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUI(
            widget.title,
            style: CustomTextStyle(
              fontSize: AppFontSize.lg,
              fontWeight: widget.fontWeight,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            TextUI(
              widget.subtitle!,
              style: CustomTextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: AppFontWeight.light,
                color: AppColors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
