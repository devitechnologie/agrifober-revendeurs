import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/gen/fonts.gen.dart';
import 'package:agrifober_resellers/config/theme/app_colors.dart';

ThemeData theme = ThemeData(
  primarySwatch: Colors.grey,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: AppColors.primary,
    selectionColor: AppColors.primary.withValues(alpha: 0.3),
    selectionHandleColor: AppColors.primary,
  ),
  scaffoldBackgroundColor: AppColors.white,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.primary,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.primary),
    centerTitle: false,
    surfaceTintColor: Colors.transparent,
  ),
  fontFamily: FontFamily.roobertPRO,
);
