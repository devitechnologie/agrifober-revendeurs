import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/config/config.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Function? onBackPressed;
  final bool showBackButton;

  const MainAppBar({
    super.key,
    this.title,
    this.actions,
    this.onBackPressed,
    this.showBackButton = true,
  });

  void _handleBack(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? Container(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Center(
                child: IconButtonUI(
                  backgroundColor: Colors.transparent,
                  onPressed: () => _handleBack(context),
                  icon: AppIcons.arrowBack,
                  iconSize: AppFontSize.xl + 2,
                ),
              ),
            )
          : null,
      leadingWidth: showBackButton ? null : 0,
      backgroundColor: AppColors.white,
      title: title != null
          ? TextUI(
              title!,
              style: CustomTextStyle(
                color: AppColors.black,
                fontWeight: AppFontWeight.bold,
                fontSize: AppFontSize.lg,
              ),
            )
          : null,
      centerTitle: false,
      actions: [
        if (actions != null) ...[
          ...actions!,
          const SizedBox(width: AppSpacing.base),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
