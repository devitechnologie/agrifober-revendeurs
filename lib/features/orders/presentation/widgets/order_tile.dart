import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return DocumentTileUI(
      icon: AppIcons.cartRR,
      title: 'Commande du ${Helpers.formatDate(order.createdAt.toLocal())}',
      subtitle: [
        Helpers.plural(order.linesCount, 'produit'),
        if (order.hasDeliveryNote) 'Bon de livraison émis',
      ].join(' · '),
      amount: Helpers.formatMad(order.total),
      badge: StatusBadgeUI(
        label: order.status.label,
        variant: order.status.badge,
      ),
      footnote:
          order.status == OrderStatus.refused && order.refusalReason.isNotEmpty
          ? 'Motif : ${order.refusalReason}'
          : null,
      footnoteColor: AppColors.danger,
      onTap: () => context.push(Routes.orderDetails.route(uid: order.uid)),
    );
  }
}
