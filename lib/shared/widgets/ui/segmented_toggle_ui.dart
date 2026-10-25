import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';

/// Pill segmented control: light green track, the selected segment a white
/// pill with green bold text.
class SegmentedToggleUI extends StatelessWidget {
  const SegmentedToggleUI({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onChanged,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.tiny),
      ),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++)
            Expanded(
              child: _Segment(
                label: items[i],
                isSelected: i == selectedIndex,
                onTap: onChanged == null ? null : () => onChanged!(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.small);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.white : Colors.transparent,
        borderRadius: radius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxs,
              vertical: AppSpacing.xs + 2,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: TextUI(
                label,
                textAlign: CustomTextAlign.center,
                maxLines: 1,
                style: CustomTextStyle(
                  fontSize: AppFontSize.xs + 1,
                  fontWeight: isSelected
                      ? AppFontWeight.bold
                      : AppFontWeight.medium,
                  color: isSelected ? AppColors.primary : AppColors.black54,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
