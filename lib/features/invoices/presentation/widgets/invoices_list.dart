import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/invoices/domain/domain.dart';
import 'package:agrifober_resellers/features/invoices/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/invoices/presentation/widgets/invoice_tile.dart';

class InvoicesList extends ConsumerWidget {
  const InvoicesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginatedListUI<Invoice>(
      state: ref.watch(invoicesProvider),
      skeletons: InvoiceMock.skeletons(),
      itemBuilder: (context, invoice) => InvoiceTile(invoice: invoice),
      empty: EmptyStateUI(
        icon: AppIcons.documentRR,
        title: 'Aucune facture',
        description: 'Aucune facture pour le moment.',
      ),
      onRefresh: () => ref.refresh(invoicesProvider.future),
      onLoadMore: () => ref.read(invoicesProvider.notifier).loadMore(),
    );
  }
}
