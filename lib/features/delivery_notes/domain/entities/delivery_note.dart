import 'package:equatable/equatable.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';

/// A bon de livraison issued to the revendeur, as listed.
class DeliveryNote extends Equatable {
  final String uid;
  final DateTime date;
  final String pointOfSale;
  final int linesCount;
  final double total;
  final PaymentMethod paymentMethod;
  final double amountPaid;

  /// Unpaid part of a credit bon; 0 otherwise.
  final double remaining;

  const DeliveryNote({
    required this.uid,
    required this.date,
    required this.pointOfSale,
    required this.linesCount,
    required this.total,
    required this.paymentMethod,
    required this.amountPaid,
    required this.remaining,
  });

  @override
  List<Object?> get props => [
    uid,
    date,
    pointOfSale,
    linesCount,
    total,
    paymentMethod,
    amountPaid,
    remaining,
  ];
}

/// A bon de livraison with its lines.
class DeliveryNoteDetails extends Equatable {
  final DeliveryNote deliveryNote;
  final double subtotal;
  final double discount;
  final List<DocumentLine> lines;

  const DeliveryNoteDetails({
    required this.deliveryNote,
    required this.subtotal,
    required this.discount,
    required this.lines,
  });

  @override
  List<Object?> get props => [deliveryNote, subtotal, discount, lines];
}
