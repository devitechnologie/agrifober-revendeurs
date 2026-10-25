import 'package:flutter/material.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/documents/documents.dart';
import 'package:agrifober_resellers/features/invoices/domain/domain.dart';

/// A facture row; tapping it opens a sheet with the amounts and the PDF.
class InvoiceTile extends StatelessWidget {
  const InvoiceTile({super.key, required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return DocumentTileUI(
      icon: AppIcons.documentRR,
      title: 'Facture du ${Helpers.formatDate(invoice.date)}',
      subtitle: [
        Helpers.plural(invoice.linesCount, 'ligne'),
        if (invoice.dueDate != null)
          'Échéance ${Helpers.formatDate(invoice.dueDate!)}',
      ].join(' · '),
      amount: Helpers.formatMad(invoice.total),
      badge: StatusBadgeUI(
        label: invoice.status.label,
        variant: invoice.status.badge,
      ),
      footnote: invoice.outstanding > 0
          ? 'Reste à payer : ${Helpers.formatMad(invoice.outstanding)}'
          : null,
      footnoteColor: AppColors.danger,
      onTap: () => _showDetails(context),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            0,
            AppSpacing.base,
            AppSpacing.base,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InfoRowUI(label: 'Date', value: Helpers.formatDate(invoice.date)),
              if (invoice.dueDate != null)
                InfoRowUI(
                  label: 'Échéance',
                  value: Helpers.formatDate(invoice.dueDate!),
                ),
              InfoRowUI(label: 'Statut', value: invoice.status.label),
              InfoRowUI(
                label: 'Total',
                value: Helpers.formatMad(invoice.total),
                bold: true,
              ),
              InfoRowUI(
                label: 'Montant payé',
                value: Helpers.formatMad(invoice.amountPaid),
              ),
              InfoRowUI(
                label: 'Reste à payer',
                value: Helpers.formatMad(invoice.outstanding),
                valueColor: invoice.outstanding > 0
                    ? AppColors.danger
                    : AppColors.green,
              ),
              const SizedBox(height: AppSpacing.base),
              DownloadDocumentButton(
                kind: DocumentKind.invoice,
                uid: invoice.uid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
