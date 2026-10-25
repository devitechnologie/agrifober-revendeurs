import 'package:flutter/material.dart';
// Local imports
import 'package:agrifober_resellers/config/config.dart';

class CheckboxUI extends StatelessWidget {
  const CheckboxUI({
    super.key,
    this.checked = false,
    this.onChange,
    this.showError = false,
    this.size = 22.0,
  });

  final bool checked;
  final ValueChanged<bool>? onChange;
  final bool showError;
  final double size;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (onChange != null) {
            onChange!(!checked); // toggle
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: checked ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: checked
                  ? AppColors.primary
                  : showError
                  ? AppColors.danger
                  : AppColors.gray500,
              width: 1.2,
            ),
          ),
          child: checked
              ? Center(
                  child: AppIcons.checkRR(
                    color: AppColors.white,
                    size: AppFontSize.sm,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
