import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/text_ui.dart';

/// `−  3  +` — quantity picker of the catalogue and the cart. At 0 it shows a
/// single "Ajouter" button instead.
class QuantityStepperUI extends StatelessWidget {
  const QuantityStepperUI({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return SizedBox(
        height: 36,
        child: OutlinedButton(
          onPressed: onIncrement,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.small),
            ),
          ),
          child: TextUI(
            'Ajouter',
            style: CustomTextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: AppFontWeight.medium,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _button(AppIcons.minusSmallRR, onDecrement, 'Retirer'),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 32),
            child: TextUI(
              '$value',
              textAlign: CustomTextAlign.center,
              style: CustomTextStyle(
                fontSize: AppFontSize.base,
                fontWeight: AppFontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          _button(AppIcons.plusSmallRR, onIncrement, 'Ajouter'),
        ],
      ),
    );
  }

  Widget _button(AppIcon icon, VoidCallback onTap, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.small),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: icon(color: AppColors.primary, size: AppFontSize.lg),
          ),
        ),
      ),
    );
  }
}
