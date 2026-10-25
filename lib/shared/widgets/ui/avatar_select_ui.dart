import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/avatar_ui.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';
import 'package:agrifober_resellers/shared/widgets/wrapper/modal_sheet_wrapper.dart';

class AvatarSelectItem {
  const AvatarSelectItem({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? avatarUrl;
}

class AvatarSelectUI extends StatelessWidget {
  const AvatarSelectUI({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.showErrorText = true,
  });

  final String hintText;
  final List<AvatarSelectItem> items;
  final AvatarSelectItem? value;
  final ValueChanged<AvatarSelectItem?>? onChanged;
  final bool enabled;
  final String? errorText;
  final bool showErrorText;

  Future<void> _onTap(BuildContext context) async {
    final selected = await showAdaptiveModalSheet<AvatarSelectItem>(
      context: context,
      builder: (ctx, ref) => ModalSheetWrapper(
        modalRef: ref,
        title: hintText,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items
              .map(
                (item) => _AvatarSelectModalItem(
                  item: item,
                  isSelected: value?.id == item.id,
                  onTap: () => Navigator.of(ctx).pop(item),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected != null) {
      onChanged?.call(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: GestureDetector(
            onTap: enabled ? () => _onTap(context) : null,
            child: Container(
              height: 52,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.tiny),
                border: Border.all(
                  color: errorText != null
                      ? AppColors.danger
                      : AppColors.gray500,
                  width: errorText != null ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  if (hasValue) ...[
                    AvatarUI(
                      name: value!.name,
                      url: value!.avatarUrl,
                      radius: 14,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: TextUI(
                      hasValue ? value!.name : hintText,
                      maxLines: 1,
                      style: CustomTextStyle(
                        fontSize: AppFontSize.base - 1,
                        fontWeight: AppFontWeight.regular,
                        color: hasValue ? AppColors.primary : AppColors.black54,
                        height: 1.2,
                      ),
                    ),
                  ),
                  AppIcons.arrowDownIconRR(
                    size: AppFontSize.base,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showErrorText && errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: TextUI(
              errorText!,
              style: CustomTextStyle(
                color: AppColors.danger,
                fontSize: AppFontSize.sm,
              ),
            ),
          ),
      ],
    );
  }
}

class _AvatarSelectModalItem extends StatelessWidget {
  const _AvatarSelectModalItem({
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  final AvatarSelectItem item;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              AvatarUI(name: item.name, url: item.avatarUrl, radius: 16),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextUI(
                  item.name,
                  style: CustomTextStyle(
                    color: AppColors.primary,
                    fontSize: AppFontSize.base - 1,
                    fontWeight: isSelected
                        ? AppFontWeight.medium
                        : AppFontWeight.regular,
                  ),
                ),
              ),
              if (isSelected)
                AppIcons.checkRR(
                  size: AppFontSize.base,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
