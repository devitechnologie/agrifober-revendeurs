import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';

class OtpFieldUI extends StatefulWidget {
  const OtpFieldUI({
    super.key,
    this.fieldWidth = 48.0,
    this.fieldHeight = 48.0,
    this.autoFocus = false,
    this.enabled = true,
    this.onCompleted,
    this.onChanged,
    this.errorText,
  });

  final double fieldWidth;
  final double fieldHeight;
  final bool autoFocus;
  final bool enabled;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final String? errorText;

  @override
  State<OtpFieldUI> createState() => _OtpFieldUIState();
}

class _OtpFieldUIState extends State<OtpFieldUI> {
  late PinInputController _controller;

  bool get hasError => widget.errorText != null && widget.errorText!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = PinInputController();
  }

  @override
  void didUpdateWidget(covariant OtpFieldUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      if (hasError) {
        _controller.triggerError();
      } else {
        _controller.clearError();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialPinField(
      length: 6,
      keyboardType: TextInputType.number,
      autoFocus: widget.autoFocus,
      enabled: widget.enabled,
      pinController: _controller,
      errorText: widget.errorText,
      errorTextStyle: TextStyle(
        color: AppColors.danger,
        fontSize: AppFontSize.sm,
      ),
      onChanged: widget.onChanged,
      onCompleted: widget.onCompleted,
      theme: MaterialPinTheme(
        shape: MaterialPinShape.outlined,
        cellSize: Size(widget.fieldWidth, widget.fieldHeight),
        borderRadius: BorderRadius.circular(AppRadius.small),
        cursorColor: AppColors.primary,
        textStyle: TextStyle(
          fontSize: AppFontSize.lg,
          fontWeight: FontWeight.w600,
          color: widget.enabled ? AppColors.primary : AppColors.gray600,
        ),
        borderColor: AppColors.gray600,
        focusedBorderColor: AppColors.primary,
        filledBorderColor: AppColors.primary,
        fillColor: AppColors.white,
        focusedFillColor: AppColors.primary.withValues(alpha: 0.1),
        filledFillColor: AppColors.primary.withValues(alpha: 0.1),
        errorColor: AppColors.danger,
        errorFillColor: AppColors.danger.withValues(alpha: 0.1),
        errorBorderColor: AppColors.danger,
      ),
    );
  }
}
