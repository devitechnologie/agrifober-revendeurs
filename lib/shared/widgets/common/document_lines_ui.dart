import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/widgets/ui/index.dart';
import 'package:agrifober_resellers/shared/widgets/common/section_card_ui.dart';

/// "Produits" card of a vente / bon / commande: one row per line
/// (designation, qty × unit price, line total).
class DocumentLinesUI extends StatelessWidget {
  const DocumentLinesUI({super.key, required this.lines});

  final List<DocumentLine> lines;

  @override
  Widget build(BuildContext context) {
    return SectionCardUI(
      title: 'Produits',
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.base,
        AppSpacing.base,
        AppSpacing.xs,
      ),
      child: Column(
        children: [
          for (final (index, line) in lines.indexed)
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                border: index == lines.length - 1
                    ? null
                    : const Border(bottom: BorderSide(color: AppColors.gray)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextUI(
                          line.designation,
                          style: CustomTextStyle(
                            fontSize: AppFontSize.sm,
                            fontWeight: AppFontWeight.medium,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        TextUI(
                          '${_qty(line.qty)} × ${Helpers.formatMad(line.unitPrice)}',
                          style: CustomTextStyle(
                            fontSize: AppFontSize.xs,
                            color: AppColors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  TextUI(
                    Helpers.formatMad(line.total),
                    style: CustomTextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: AppFontWeight.medium,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static String _qty(double qty) =>
      qty == qty.truncateToDouble() ? qty.toStringAsFixed(0) : '$qty';
}
