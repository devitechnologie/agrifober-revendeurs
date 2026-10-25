import 'package:flutter/material.dart';
// Local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';

enum SelectFieldVariant { primary }

class SelectUI<T> extends StatefulWidget {
  const SelectUI({
    super.key,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.prefix,
    this.enabled = true,
    this.errorText,
    this.showErrorText = true,
    this.variant = SelectFieldVariant.primary,
  });

  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final Widget? prefix;
  final bool enabled;
  final String? errorText;
  final bool showErrorText;
  final SelectFieldVariant variant;

  @override
  State<SelectUI<T>> createState() => _SelectUIState<T>();
}

class _SelectUIState<T> extends State<SelectUI<T>> {
  late FocusNode _focusNode;

  bool get hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  InputDecoration get _inputStyle {
    switch (widget.variant) {
      case SelectFieldVariant.primary:
        return InputStyles.primaryInputDecoration(
          hintText: '',
          paddingLeft: widget.prefix != null ? 46 : null,
          hasError: hasError,
        );
    }
  }

  Widget get _hint => Text(
    widget.hintText,
    style: const TextStyle(
      fontSize: AppFontSize.base - 1,
      fontWeight: AppFontWeight.regular,
      color: AppColors.black54,
    ),
  );

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TapRegion(
              onTapOutside: (_) => _focusNode.unfocus(),
              child: DropdownButtonFormField<T>(
                focusNode: _focusNode,
                hint: _hint,
                initialValue: widget.value,
                items: widget.items,
                onChanged: widget.enabled
                    ? (v) {
                        widget.onChanged?.call(v);
                        _focusNode.unfocus();
                      }
                    : null,
                decoration: _inputStyle,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: AppFontSize.base - 1,
                  fontWeight: AppFontWeight.regular,
                ),
                selectedItemBuilder: (_) => widget.items
                    .map(
                      (item) => Align(
                        alignment: Alignment.centerLeft,
                        child: DefaultTextStyle.merge(
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: AppFontSize.base - 1,
                            fontWeight: AppFontWeight.regular,
                          ),
                          child: item.child,
                        ),
                      ),
                    )
                    .toList(),
                dropdownColor: AppColors.white,
                icon: Container(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: AppIcons.arrowSmallDownRR(
                    color: AppColors.black87,
                    size: AppFontSize.xxs,
                  ),
                ),
              ),
            ),
            if (widget.prefix != null)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.md),
                    child: widget.prefix!,
                  ),
                ),
              ),
          ],
        ),
        if (hasError && widget.showErrorText)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: TextUI(
              widget.errorText ?? '',
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
