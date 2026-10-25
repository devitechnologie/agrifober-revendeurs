import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';

class LabelUI extends StatelessWidget {
  const LabelUI(this.text, {super.key, this.style, this.hint});

  final String text;
  final TextStyle? style;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = const TextStyle(
      fontSize: AppFontSize.base - 1,
      fontWeight: AppFontWeight.medium,
      color: AppColors.black,
    );

    if (hint == null) {
      return Text(text, style: defaultStyle.merge(style));
    }

    return Text.rich(
      TextSpan(
        text: text,
        style: defaultStyle.merge(style),
        children: [
          TextSpan(
            text: '  $hint',
            style: const TextStyle(
              fontSize: AppFontSize.base - 1,
              fontWeight: AppFontWeight.light,
              color: AppColors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
