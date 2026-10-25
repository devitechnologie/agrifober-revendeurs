import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
// Local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/widgets/widgets.dart';

enum PhoneFieldVariant { primary }

typedef PhoneFieldChangedCallback =
    void Function({required String value, int? dialCode});

class PhoneFieldUI extends StatefulWidget {
  const PhoneFieldUI({
    super.key,
    this.onChanged,
    this.onFocus,
    this.onBlur,
    this.validator,
    this.errorText,
    this.showErrorText = true,
    this.value,
    this.dialCode,
    this.initialSelection,
    this.favorite,
    this.variant = PhoneFieldVariant.primary,
    this.hintText = 'Tapez votre numéro de téléphone',
  });

  final PhoneFieldChangedCallback? onChanged;
  final void Function()? onFocus;
  final void Function()? onBlur;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool showErrorText;
  final String? value;
  final PhoneFieldVariant variant;
  final int? dialCode;
  final String? initialSelection;
  final List<String>? favorite;
  final String hintText;

  @override
  State<PhoneFieldUI> createState() => _PhoneFieldUIState();
}

class _PhoneFieldUIState extends State<PhoneFieldUI> {
  int _selectedDialCode = defaultPhoneDialCode;
  String _inputValue = '';
  String? _initialSelection;
  List<String>? _favorite;

  /// Only one country is supported by the backend for now: the picker is
  /// displayed as a locked badge instead of an openable dialog.
  bool get _isSingleCountry => supportedPhoneCountries.length <= 1;

  @override
  void initState() {
    super.initState();
    _inputValue = widget.value ?? '';
    _selectedDialCode = _isSingleCountry
        ? supportedPhoneCountries.values.first
        : widget.dialCode ?? defaultPhoneDialCode;
    _initialSelection = widget.initialSelection;
    _favorite = widget.favorite;
  }

  @override
  void didUpdateWidget(PhoneFieldUI oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      setState(() {
        _inputValue = widget.value ?? '';
      });
    }

    if (oldWidget.dialCode != widget.dialCode && !_isSingleCountry) {
      setState(() {
        _selectedDialCode = widget.dialCode ?? defaultPhoneDialCode;
      });
    }

    if (oldWidget.initialSelection != widget.initialSelection) {
      setState(() {
        _initialSelection = widget.initialSelection;
      });
    }

    if (oldWidget.favorite != widget.favorite) {
      setState(() {
        _favorite = widget.favorite;
      });
    }
  }

  Color get _borderColor {
    return widget.variant == PhoneFieldVariant.primary
        ? AppColors.gray500
        : AppColors.gray500;
  }

  TextFieldVariant variantAdapter(PhoneFieldVariant variant) {
    switch (variant) {
      case PhoneFieldVariant.primary:
        return TextFieldVariant.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: 52),
              child: _dialCodePicker(
                isError:
                    (widget.errorText != null && widget.showErrorText != false),
                initialSelection: _initialSelection,
                favorite: _favorite,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Stack(
                children: [
                  TextFieldUI(
                    variant: variantAdapter(widget.variant),
                    hintText: widget.hintText,
                    keyBoardType: TextInputType.phone,
                    onChanged: (val) {
                      setState(() => _inputValue = val);
                      if (widget.onChanged != null) {
                        widget.onChanged!(
                          value: val,
                          dialCode: _selectedDialCode,
                        );
                      }
                    },
                    onFocus: widget.onFocus,
                    onBlur: widget.onBlur,
                    validator: widget.validator,
                    value: _inputValue,
                    errorText: widget.errorText,
                    showErrorText: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (widget.errorText != null && widget.showErrorText != false)
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

  Widget _dialCodePicker({
    required bool isError,
    required String? initialSelection,
    required List<String>? favorite,
  }) {
    // Single supported country: show the dial code as a read-only badge.
    if (_isSingleCountry) {
      return _dialCodeBadge(isError: isError, showArrow: false);
    }

    return CountryCodePicker(
      headerText: 'Code de pays',
      builder: (p0) => _dialCodeBadge(isError: isError, showArrow: true),
      onChanged: (dialCode) {
        setState(() {
          _selectedDialCode =
              int.tryParse(dialCode.dialCode?.replaceAll('+', '') ?? '') ??
              defaultPhoneDialCode;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value: _inputValue, dialCode: _selectedDialCode);
        }
      },
      initialSelection: initialSelection ?? supportedPhoneCountries.keys.first,
      favorite: favorite ?? const ['+212', 'MA'],
      countryFilter: supportedPhoneCountries.keys.toList(),
      hideSearch: false,
      padding: EdgeInsets.zero,
    );
  }

  Widget _dialCodeBadge({required bool isError, required bool showArrow}) {
    return IntrinsicWidth(
      child: Container(
        color: AppColors.white,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 13.2,
          ),
          constraints: const BoxConstraints(minHeight: 52),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.tiny),
            border: Border.all(
              color: isError ? AppColors.danger : _borderColor,
              width: isError ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              TextUI(
                '+$_selectedDialCode',
                style: CustomTextStyle(
                  fontSize: AppFontSize.sm + 1,
                  fontWeight: AppFontWeight.light,
                  color: AppColors.black87,
                ),
              ),
              if (showArrow) ...[
                const SizedBox(width: AppSpacing.sm),
                AppIcons.arrowDownIconRR(
                  size: AppFontSize.base,
                  color: AppColors.black54,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
