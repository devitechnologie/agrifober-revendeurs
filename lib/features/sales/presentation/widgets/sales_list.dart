import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/sales/domain/domain.dart';
import 'package:agrifober_resellers/features/sales/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/sales/presentation/widgets/sale_tile.dart';

class SalesList extends ConsumerWidget {
  const SalesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginatedListUI<Sale>(
      state: ref.watch(salesProvider),
      skeletons: SaleMock.skeletons(),
      itemBuilder: (context, sale) => SaleTile(sale: sale),
      empty: EmptyStateUI(
        icon: AppIcons.receiptRR,
        title: 'Aucun achat',
        description: 'Aucun achat pour le moment.',
      ),
      onRefresh: () => ref.refresh(salesProvider.future),
      onLoadMore: () => ref.read(salesProvider.notifier).loadMore(),
    );
  }
}
