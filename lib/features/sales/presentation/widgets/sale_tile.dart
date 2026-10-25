import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/sales/domain/domain.dart';

class SaleTile extends StatelessWidget {
  const SaleTile({super.key, required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final onCredit = sale.paymentMethod == PaymentMethod.credit;

    return DocumentTileUI(
      icon: AppIcons.receiptRR,
      title: 'Achat du ${Helpers.formatDate(sale.date)}',
      subtitle: [
        sale.type.label,
        if (sale.pointOfSale.isNotEmpty) sale.pointOfSale,
        Helpers.plural(sale.linesCount, 'ligne'),
      ].join(' · '),
      amount: Helpers.formatMad(sale.total),
      badge: onCredit
          ? StatusBadgeUI(
              label: sale.isOverdue ? 'Échu' : 'Crédit',
              variant: sale.isOverdue
                  ? StatusBadgeVariant.danger
                  : StatusBadgeVariant.warning,
            )
          : null,
      footnote: onCredit && sale.remaining > 0
          ? 'Reste à payer : ${Helpers.formatMad(sale.remaining)}'
          : null,
      footnoteColor: sale.isOverdue ? AppColors.danger : AppColors.black54,
      onTap: () => context.push(Routes.saleDetails.route(uid: sale.uid)),
    );
  }
}
