import 'package:equatable/equatable.dart';

/// One product line of a vente, bon de livraison or commande.
class DocumentLine extends Equatable {
  final String productUid;
  final String designation;
  final double qty;
  final double unitPrice;
  final double total;

  const DocumentLine({
    required this.productUid,
    required this.designation,
    required this.qty,
    required this.unitPrice,
    required this.total,
  });

  @override
  List<Object?> get props => [productUid, designation, qty, unitPrice, total];
}

/// How a vente or bon was paid. [none] = recorded by hand, no payment info.
enum PaymentMethod { cash, credit, none }
