import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';

class SwitchUI extends StatelessWidget {
  const SwitchUI({
    super.key,
    required this.value,
    required this.onChanged,
    this.scale = 0.75,
    this.activeColor,
    this.inactiveTrackColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  /// Scale factor applied to the native Switch. Defaults to 0.75.
  final double scale;

  /// Track + thumb color when active. Defaults to [AppColors.green].
  final Color? activeColor;

  /// Track color when inactive. Defaults to [AppColors.gray500].
  final Color? inactiveTrackColor;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Switch(
        value: value,
        padding: EdgeInsets.zero,
        onChanged: onChanged,
        activeThumbColor: AppColors.white,
        activeTrackColor: activeColor ?? AppColors.green,
        inactiveTrackColor: inactiveTrackColor ?? AppColors.gray500,
        inactiveThumbColor: AppColors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
