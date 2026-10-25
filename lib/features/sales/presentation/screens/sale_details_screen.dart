import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/documents/documents.dart';
import 'package:agrifober_resellers/features/sales/domain/domain.dart';
import 'package:agrifober_resellers/features/sales/presentation/providers/index.dart';

class SaleDetailsScreen extends ConsumerWidget {
  const SaleDetailsScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(saleDetailsProvider(uid));

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: const MainAppBar(title: 'Achat'),
      body: details.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: AppColors.primary,
          ),
        ),
        error: (error, _) => ErrorStateUI(
          error: error,
          onRetry: () => ref.invalidate(saleDetailsProvider(uid)),
        ),
        data: (details) => _buildContent(details),
      ),
    );
  }

  Widget _buildContent(SaleDetails details) {
    final sale = details.sale;
    final onCredit = sale.paymentMethod == PaymentMethod.credit;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.base),
      children: [
        SectionCardUI(
          title: 'Informations',
          trailing: onCredit
              ? StatusBadgeUI(
                  label: sale.isOverdue ? 'Échu' : 'Crédit',
                  variant: sale.isOverdue
                      ? StatusBadgeVariant.danger
                      : StatusBadgeVariant.warning,
                )
              : null,
          child: Column(
            children: [
              InfoRowUI(label: 'Date', value: Helpers.formatDate(sale.date)),
              InfoRowUI(label: 'Canal', value: sale.type.label),
              if (sale.pointOfSale.isNotEmpty)
                InfoRowUI(label: 'Point de vente', value: sale.pointOfSale),
              InfoRowUI(label: 'Paiement', value: sale.paymentMethod.label),
              if (onCredit) ...[
                InfoRowUI(
                  label: 'Montant payé',
                  value: Helpers.formatMad(sale.amountPaid),
                ),
                InfoRowUI(
                  label: 'Reste à payer',
                  value: Helpers.formatMad(sale.remaining),
                  valueColor: sale.remaining > 0
                      ? AppColors.danger
                      : AppColors.green,
                ),
                InfoRowUI(
                  label: 'Échéance',
                  value: sale.dueDate == null
                      ? 'Sans échéance'
                      : Helpers.formatDate(sale.dueDate!),
                  valueColor: sale.isOverdue
                      ? AppColors.danger
                      : AppColors.black,
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
              if (details.deliveryPrice > 0)
                InfoRowUI(
                  label: 'Livraison',
                  value: Helpers.formatMad(details.deliveryPrice),
                ),
              InfoRowUI(
                label: 'Total',
                value: Helpers.formatMad(sale.total),
                valueColor: AppColors.primary,
                bold: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        DownloadDocumentButton(kind: DocumentKind.sale, uid: sale.uid),
      ],
    );
  }
}
