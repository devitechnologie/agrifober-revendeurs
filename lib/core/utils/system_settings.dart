import 'package:flutter/services.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';

void applySystemUIStyle({
  Color color = AppColors.white,
  Brightness brightness = Brightness.dark,
  double opacity = 0.7,
}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color.withValues(alpha: opacity),
      statusBarIconBrightness: brightness,
      systemNavigationBarColor: color,
      systemNavigationBarIconBrightness: brightness,
    ),
  );
}

void applyStatusBarStyle({
  Color color = AppColors.white,
  Brightness brightness = Brightness.dark,
  double opacity = 0.7,
}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color.withValues(alpha: opacity),
      statusBarIconBrightness: brightness,
    ),
  );
}
