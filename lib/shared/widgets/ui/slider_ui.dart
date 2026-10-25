import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';

class SliderUI extends StatelessWidget {
  const SliderUI({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 1,
    this.onChanged,
  });

  final double value;
  final double min;
  final double max;

  /// A null callback renders a static, non draggable track.
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: AppSpacing.xxs,
        padding: EdgeInsets.zero,
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.gray,
        disabledActiveTrackColor: AppColors.primary,
        disabledInactiveTrackColor: AppColors.gray,
        thumbColor: AppColors.primary,
        disabledThumbColor: AppColors.primary,
        overlayShape: SliderComponentShape.noOverlay,
        trackShape: const RoundedRectSliderTrackShape(),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: AppSpacing.xxs + 1,
          disabledThumbRadius: AppSpacing.xxs + 1,
          elevation: 0,
          pressedElevation: 0,
        ),
      ),
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        onChanged: onChanged,
      ),
    );
  }
}
