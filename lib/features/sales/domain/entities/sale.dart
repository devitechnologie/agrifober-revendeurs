import 'package:equatable/equatable.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';

/// Where a vente happened: in store, at the farm, or online (with delivery).
enum SaleType { store, farm, online }

/// A vente to the revendeur, as listed.
class Sale extends Equatable {
  final String uid;
  final DateTime date;
  final SaleType type;
  final String pointOfSale;
  final int linesCount;
  final double total;
  final PaymentMethod paymentMethod;
  final double amountPaid;

  /// Unpaid part of a credit vente; 0 otherwise.
  final double remaining;

  /// Échéance of a credit vente, if one was set.
  final DateTime? dueDate;
  final bool isOverdue;

  const Sale({
    required this.uid,
    required this.date,
    required this.type,
    required this.pointOfSale,
    required this.linesCount,
    required this.total,
    required this.paymentMethod,
    required this.amountPaid,
    required this.remaining,
    required this.dueDate,
    required this.isOverdue,
  });

  @override
  List<Object?> get props => [
    uid,
    date,
    type,
    pointOfSale,
    linesCount,
    total,
    paymentMethod,
    amountPaid,
    remaining,
    dueDate,
    isOverdue,
  ];
}

/// A vente with its lines and the amounts behind its total.
class SaleDetails extends Equatable {
  final Sale sale;
  final double subtotal;
  final double discount;
  final double deliveryPrice;
  final List<DocumentLine> lines;

  const SaleDetails({
    required this.sale,
    required this.subtotal,
    required this.discount,
    required this.deliveryPrice,
    required this.lines,
  });

  @override
  List<Object?> get props => [sale, subtotal, discount, deliveryPrice, lines];
}
