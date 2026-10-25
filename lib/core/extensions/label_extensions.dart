import 'package:agrifober_resellers/core/entities/index.dart';
import 'package:agrifober_resellers/features/credit/domain/domain.dart';
import 'package:agrifober_resellers/features/invoices/domain/domain.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';
import 'package:agrifober_resellers/features/sales/domain/domain.dart';
import 'package:agrifober_resellers/shared/widgets/ui/status_badge_ui.dart';

// French labels (and badge colours) for every enum the revendeur sees. Wording
// follows the AgrifoberRapport web app so both speak the same language.

extension SaleTypeLabel on SaleType {
  String get label => switch (this) {
    SaleType.store => 'Magasin',
    SaleType.farm => 'Ferme',
    SaleType.online => 'Ecom',
  };
}

extension PaymentMethodLabel on PaymentMethod {
  String get label => switch (this) {
    PaymentMethod.cash => 'Comptant',
    PaymentMethod.credit => 'Crédit',
    PaymentMethod.none => '—',
  };
}

extension InvoiceStatusLabel on InvoiceStatus {
  String get label => switch (this) {
    InvoiceStatus.sent => 'Envoyée',
    InvoiceStatus.paid => 'Payée',
  };

  StatusBadgeVariant get badge => switch (this) {
    InvoiceStatus.sent => StatusBadgeVariant.warning,
    InvoiceStatus.paid => StatusBadgeVariant.success,
  };
}

extension OrderStatusLabel on OrderStatus {
  String get label => switch (this) {
    OrderStatus.pending => 'En attente',
    OrderStatus.confirmed => 'Confirmée',
    OrderStatus.delivered => 'Livrée',
    OrderStatus.refused => 'Refusée',
    OrderStatus.cancelled => 'Annulée',
  };

  StatusBadgeVariant get badge => switch (this) {
    OrderStatus.pending => StatusBadgeVariant.warning,
    OrderStatus.confirmed => StatusBadgeVariant.info,
    OrderStatus.delivered => StatusBadgeVariant.success,
    OrderStatus.refused => StatusBadgeVariant.danger,
    OrderStatus.cancelled => StatusBadgeVariant.neutral,
  };
}

extension CreditItemTypeLabel on CreditItemType {
  String get label => switch (this) {
    CreditItemType.sale => 'Achat',
    CreditItemType.deliveryNote => 'Bon de livraison',
    CreditItemType.manual => 'Manuel',
  };
}
