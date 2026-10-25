import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/icon_button_ui.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';

class ContextMenuItem {
  const ContextMenuItem({
    required this.value,
    required this.icon,
    required this.label,
    this.color = AppColors.primary,
    this.dividerBefore = false,
    this.onSelected,
  });

  final String value;
  final AppIcon icon;
  final String label;
  final Color color;
  final bool dividerBefore;
  final VoidCallback? onSelected;
}

/// A button that anchors a [showMenu] popup to itself.
///
/// By default renders an [IconButtonUI] with the vertical-dots icon.
/// Pass [builder] to use a custom trigger widget.
class ContextMenuButton extends StatelessWidget {
  const ContextMenuButton({super.key, required this.items, this.builder});

  final List<ContextMenuItem> items;

  /// Custom trigger. Receives [onPressed] and must call it to open the menu.
  /// Defaults to a vertical-dots [IconButtonUI].
  final Widget Function(VoidCallback onPressed)? builder;

  PopupMenuEntry<String> _buildItem(ContextMenuItem item) {
    return PopupMenuItem<String>(
      value: item.value,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          item.icon(color: item.color, size: AppFontSize.base),
          const SizedBox(width: AppSpacing.sm),
          TextUI(
            item.label,
            style: CustomTextStyle(
              fontSize: AppFontSize.sm + 1,
              fontWeight: AppFontWeight.medium,
              color: item.color,
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final menuItems = <PopupMenuEntry<String>>[];
    for (final item in items) {
      if (item.dividerBefore) {
        menuItems.add(
          const PopupMenuDivider(
            height: 1,
            thickness: 1,
            color: AppColors.gray500,
          ),
        );
      }
      menuItems.add(_buildItem(item));
    }

    showMenu<String>(
      context: context,
      position: position,
      color: AppColors.white,
      elevation: 8,
      shadowColor: AppColors.gray600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.tiny),
        side: const BorderSide(color: AppColors.gray),
      ),
      items: menuItems,
    ).then((value) {
      if (value == null) return;
      final match = items.where((i) => i.value == value).firstOrNull;
      match?.onSelected?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      return builder!(() => _showMenu(context));
    }
    return IconButtonUI(
      onPressed: () => _showMenu(context),
      icon: AppIcons.menuDotsVerticalRR,
      iconSize: AppFontSize.base,
    );
  }
}
