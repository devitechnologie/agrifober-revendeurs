import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/documents/documents.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/domain.dart';
import 'package:agrifober_resellers/features/delivery_notes/presentation/providers/index.dart';

class DeliveryNoteDetailsScreen extends ConsumerWidget {
  const DeliveryNoteDetailsScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(deliveryNoteDetailsProvider(uid));

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: const MainAppBar(title: 'Bon de livraison'),
      body: details.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: AppColors.primary,
          ),
        ),
        error: (error, _) => ErrorStateUI(
          error: error,
          onRetry: () => ref.invalidate(deliveryNoteDetailsProvider(uid)),
        ),
        data: (details) => _buildContent(details),
      ),
    );
  }

  Widget _buildContent(DeliveryNoteDetails details) {
    final note = details.deliveryNote;
    final onCredit = note.paymentMethod == PaymentMethod.credit;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.base),
      children: [
        SectionCardUI(
          title: 'Informations',
          trailing: onCredit
              ? const StatusBadgeUI(
                  label: 'Crédit',
                  variant: StatusBadgeVariant.warning,
                )
              : null,
          child: Column(
            children: [
              InfoRowUI(label: 'Date', value: Helpers.formatDate(note.date)),
              if (note.pointOfSale.isNotEmpty)
                InfoRowUI(label: 'Point de vente', value: note.pointOfSale),
              InfoRowUI(label: 'Paiement', value: note.paymentMethod.label),
              if (onCredit) ...[
                InfoRowUI(
                  label: 'Montant payé',
                  value: Helpers.formatMad(note.amountPaid),
                ),
                InfoRowUI(
                  label: 'Reste à payer',
                  value: Helpers.formatMad(note.remaining),
                  valueColor: note.remaining > 0
                      ? AppColors.danger
                      : AppColors.green,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DocumentLinesUI(lines: details.lines),
        const SizedBox(height: AppSpacing.sm),
        SectionCardUI(
          child: Column(
            children: [
              InfoRowUI(
                label: 'Sous-total',
                value: Helpers.formatMad(details.subtotal),
              ),
              if (details.discount > 0)
                InfoRowUI(
                  label: 'Remise',
                  value: '-${Helpers.formatMad(details.discount)}',
                ),
              InfoRowUI(
                label: 'Total',
                value: Helpers.formatMad(note.total),
                valueColor: AppColors.primary,
                bold: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        DownloadDocumentButton(kind: DocumentKind.deliveryNote, uid: note.uid),
      ],
    );
  }
}
