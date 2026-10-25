import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/label_ui.dart';

class LabeledFieldUI extends StatelessWidget {
  final String label;
  final Widget child;
  final String? hint;

  const LabeledFieldUI({
    super.key,
    required this.label,
    required this.child,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelUI(label, hint: hint),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }
}
