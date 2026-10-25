import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';

enum TextFieldVariant { primary, secondary }

class TextFieldUI extends StatefulWidget {
  const TextFieldUI({
    super.key,
    required this.hintText,
    this.variant = TextFieldVariant.primary,
    this.onFocus,
    this.onBlur,
    this.useClearButton = false,
    this.autoFocus = false,
    this.defaultValue,
    this.enabled = true,
    this.outline = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefix,
    this.prefixSpacing = 46,
    this.paddingLeft,
    this.paddingRight,
    this.keyBoardType,
    this.isPassword = false,
    this.onChanged,
    this.validator,
    this.value,
    this.errorText,
    this.showErrorText,
    this.autofillHints,
  });

  final String hintText;
  final TextFieldVariant variant;
  final void Function()? onFocus;
  final void Function()? onBlur;
  final bool useClearButton;
  final bool autoFocus;
  final String? defaultValue;
  final bool enabled;
  final bool outline;
  final int maxLines;
  final int? maxLength;
  final Widget? prefix;
  final double prefixSpacing;
  final double? paddingLeft;
  final double? paddingRight;
  final TextInputType? keyBoardType;
  final bool isPassword;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? value;
  final String? errorText;
  final bool? showErrorText;
  final Iterable<String>? autofillHints;

  bool get hasError => errorText != null && errorText!.isNotEmpty;

  @override
  State<TextFieldUI> createState() => _TextFieldUIState();
}

class _TextFieldUIState extends State<TextFieldUI> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isClearVisible = false;
  bool _isPasswordVisible = false;
  late String _lastText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _lastText = widget.value ?? widget.defaultValue ?? '';
    _controller = TextEditingController(text: _lastText);
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(() {
      final text = _controller.text;
      setState(() {
        _isClearVisible = text.isNotEmpty;
      });
      if (text != _lastText) {
        _lastText = text;
        widget.onChanged?.call(text);
      }
    });
    if (widget.defaultValue != null) {
      _controller.text = widget.defaultValue!;
    }
  }

  @override
  void didUpdateWidget(covariant TextFieldUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      if (widget.onFocus != null) {
        widget.onFocus!();
      }
    } else {
      if (widget.onBlur != null) {
        widget.onBlur!();
      }
    }
  }

  get _inputStyle {
    switch (widget.variant) {
      case TextFieldVariant.primary:
        return InputStyles.primaryInputDecoration(
          outline: widget.outline,
          hintText: widget.hintText,
          enabled: widget.enabled,
          paddingRight: widget.paddingRight,
          paddingLeft: widget.prefix != null
              ? widget.prefixSpacing
              : widget.paddingLeft,
          hasError: widget.hasError,
        );
      case TextFieldVariant.secondary:
        return InputStyles.secondaryInputDecoration(
          hintText: widget.hintText,
          enabled: widget.enabled,
          paddingRight: widget.paddingRight,
          paddingLeft: widget.prefix != null
              ? widget.prefixSpacing
              : widget.paddingLeft,
          hasError: widget.hasError,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TextFormField(
              textAlignVertical: TextAlignVertical.center,
              validator: widget.validator,
              keyboardType: widget.keyBoardType,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              enabled: widget.enabled,
              autofocus: widget.autoFocus,
              focusNode: _focusNode,
              decoration: _inputStyle,
              controller: _controller,
              obscureText: widget.isPassword ? !_isPasswordVisible : false,
              autofillHints: widget.autofillHints,
            ),
            if (widget.prefix != null) ...[
              Positioned(
                left: AppSpacing.base,
                top: 0,
                bottom: 0,
                child: Center(child: widget.prefix!),
              ),
            ],
            // length > 0 we clear the text field
            if (_isClearVisible &&
                _focusNode.hasFocus &&
                widget.useClearButton) ...[
              Positioned(
                right: AppSpacing.base,
                top: 0,
                bottom: 0,
                child: Center(child: _buildClearButton()),
              ),
            ],

            // password visibility
            if (widget.isPassword) ...[
              Positioned(
                right: AppSpacing.base,
                top: 0,
                bottom: 0,
                child: Center(child: _buildPasswordVisibility()),
              ),
            ],
          ],
        ),
        if (widget.hasError && widget.showErrorText != false)
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

  Widget _buildPasswordVisibility() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
        child: !_isPasswordVisible
            ? AppIcons.eyeRR(color: AppColors.black87, size: AppFontSize.xl)
            : AppIcons.eyeCrossedRR(
                color: AppColors.black87,
                size: AppFontSize.xl,
              ),
      ),
    );
  }

  Widget _buildClearButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _controller.clear();
          setState(() {
            _isClearVisible = false;
          });
          if (widget.onChanged != null) {
            widget.onChanged!('');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.black87,
            borderRadius: BorderRadius.circular(50),
          ),
          child: AppIcons.closeRR(
            color: AppColors.white,
            size: AppFontSize.base,
          ),
        ),
      ),
    );
  }
}
