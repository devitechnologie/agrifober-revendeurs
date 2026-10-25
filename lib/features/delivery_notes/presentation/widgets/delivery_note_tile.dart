import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/domain.dart';

class DeliveryNoteTile extends StatelessWidget {
  const DeliveryNoteTile({super.key, required this.deliveryNote});

  final DeliveryNote deliveryNote;

  @override
  Widget build(BuildContext context) {
    final note = deliveryNote;
    final onCredit = note.paymentMethod == PaymentMethod.credit;

    return DocumentTileUI(
      icon: AppIcons.truckRR,
      title: 'Bon du ${Helpers.formatDate(note.date)}',
      subtitle: [
        if (note.pointOfSale.isNotEmpty) note.pointOfSale,
        Helpers.plural(note.linesCount, 'ligne'),
      ].join(' · '),
      amount: Helpers.formatMad(note.total),
      badge: onCredit
          ? const StatusBadgeUI(
              label: 'Crédit',
              variant: StatusBadgeVariant.warning,
            )
          : null,
      footnote: onCredit && note.remaining > 0
          ? 'Reste à payer : ${Helpers.formatMad(note.remaining)}'
          : null,
      onTap: () =>
          context.push(Routes.deliveryNoteDetails.route(uid: note.uid)),
    );
  }
}
