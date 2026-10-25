import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/theme/app_colors.dart';
import 'package:agrifober_resellers/config/theme/app_font_sizes.dart';
import 'package:agrifober_resellers/config/theme/app_font_weight.dart';
import 'package:agrifober_resellers/config/theme/app_radius.dart';
import 'package:agrifober_resellers/config/theme/app_spacing.dart';

class InputStyles {
  static InputDecoration primaryInputDecoration({
    required String hintText,
    bool outline = true,
    bool enabled = true,
    double? paddingLeft,
    double? paddingRight,
    double? paddingTop,
    double? paddingBottom,
    bool? hasError,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: AppFontSize.base,
        fontWeight: AppFontWeight.regular,
        color: AppColors.black54,
      ),
      contentPadding: EdgeInsets.only(
        left: paddingLeft ?? AppSpacing.sm,
        right: paddingRight ?? AppSpacing.sm,
        top: paddingTop ?? AppSpacing.base - 2,
        bottom: paddingBottom ?? AppSpacing.base - 2,
      ),
      isDense: true,
      filled: true,
      fillColor: enabled ? AppColors.white : AppColors.accent,
      enabledBorder: hasError == true
          ? OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.danger, width: 2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.tiny),
              ),
            )
          : outline
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.gray500, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
            )
          : const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
            ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray500, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray500, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
      ),
      focusedBorder: outline
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
            )
          : const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
            ),
    );
  }

  static InputDecoration secondaryInputDecoration({
    required String hintText,
    bool outline = true,
    bool enabled = true,
    double? paddingLeft,
    double? paddingRight,
    double? paddingTop,
    double? paddingBottom,
    bool? hasError,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontSize: AppFontSize.base,
        fontWeight: AppFontWeight.regular,
        color: AppColors.black54,
      ),
      contentPadding: EdgeInsets.only(
        left: paddingLeft ?? AppSpacing.sm,
        right: paddingRight ?? AppSpacing.sm,
        top: paddingTop ?? AppSpacing.base - 2,
        bottom: paddingBottom ?? AppSpacing.base - 2,
      ),
      isDense: true,
      filled: true,
      fillColor: enabled
          ? AppColors.gray600.withValues(alpha: 0.2)
          : AppColors.accent,
      enabledBorder: hasError == true
          ? OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.danger, width: 2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppRadius.tiny),
              ),
            )
          : const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
            ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray500, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.gray500, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
      ),
      focusedBorder: outline
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
            )
          : const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.tiny)),
            ),
    );
  }
}
