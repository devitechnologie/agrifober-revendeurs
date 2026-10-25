import 'package:equatable/equatable.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';

/// En attente → Confirmée → Livrée, or Refusée (by Agrifober) / Annulée (by
/// the revendeur, only while pending).
enum OrderStatus { pending, confirmed, delivered, refused, cancelled }

/// A commande the revendeur placed from the app, as listed.
class Order extends Equatable {
  final String uid;
  final OrderStatus status;
  final double total;

  /// Part of [total] asked to be paid on credit (score crédit); 0 if none.
  final double creditAmount;
  final String note;
  final String refusalReason;
  final int linesCount;

  /// Agrifober turned it into a bon de livraison.
  final bool hasDeliveryNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.uid,
    required this.status,
    required this.total,
    required this.creditAmount,
    required this.note,
    required this.refusalReason,
    required this.linesCount,
    required this.hasDeliveryNote,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canBeCancelled => status == OrderStatus.pending;

  /// What is left to pay at delivery.
  double get payableAtDelivery => (total - creditAmount).clamp(0, total);

  @override
  List<Object?> get props => [
    uid,
    status,
    total,
    creditAmount,
    note,
    refusalReason,
    linesCount,
    hasDeliveryNote,
    createdAt,
    updatedAt,
  ];
}

class OrderStatusChange extends Equatable {
  final OrderStatus status;
  final DateTime at;

  const OrderStatusChange({required this.status, required this.at});

  @override
  List<Object?> get props => [status, at];
}

/// A commande with its lines and the history of its statuses.
class OrderDetails extends Equatable {
  final Order order;
  final List<DocumentLine> lines;
  final List<OrderStatusChange> history;

  const OrderDetails({
    required this.order,
    required this.lines,
    required this.history,
  });

  @override
  List<Object?> get props => [order, lines, history];
}

/// What the revendeur asks for: a product and a quantity. Prices are set by
/// the server from the catalogue.
class OrderRequestLine extends Equatable {
  final String productUid;
  final int qty;

  const OrderRequestLine({required this.productUid, required this.qty});

  @override
  List<Object?> get props => [productUid, qty];
}
