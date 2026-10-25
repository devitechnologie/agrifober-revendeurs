import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/orders/presentation/widgets/order_tile.dart';

/// The revendeur's commandes — the "Commandes" segment of Historique.
class OrdersList extends ConsumerWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginatedListUI<Order>(
      state: ref.watch(ordersProvider),
      skeletons: OrderMock.skeletons(),
      itemBuilder: (context, order) => OrderTile(order: order),
      empty: EmptyStateUI(
        icon: AppIcons.cartRR,
        title: 'Aucune commande',
        description:
            'Commandez les produits Agrifober directement depuis l\'application.',
        action: ButtonUI(
          onPressed: () => context.go(Routes.catalog.route),
          text: 'Voir le catalogue',
          width: 220,
          minHeight: 44,
          textSize: AppFontSize.base,
        ),
      ),
      onRefresh: () => ref.refresh(ordersProvider.future),
      onLoadMore: () => ref.read(ordersProvider.notifier).loadMore(),
    );
  }
}
