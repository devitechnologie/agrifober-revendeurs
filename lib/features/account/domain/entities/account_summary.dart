import 'package:equatable/equatable.dart';
// local imports
import 'package:agrifober_resellers/features/credit/domain/entities/credit_score.dart';

/// Key figures of the revendeur's account — the "Statistiques" block of the
/// web app's revendeur page, computed by the server the same way.
class AccountSummary extends Equatable {
  final int salesCount;
  final int deliveryNotesCount;
  final double revenue;
  final double outstandingCredit;
  final double unpaidInvoicesTotal;
  final int pendingOrdersCount;
  final CreditScore creditScore;

  const AccountSummary({
    required this.salesCount,
    required this.deliveryNotesCount,
    required this.revenue,
    required this.outstandingCredit,
    required this.unpaidInvoicesTotal,
    required this.pendingOrdersCount,
    required this.creditScore,
  });

  @override
  List<Object?> get props => [
    salesCount,
    deliveryNotesCount,
    revenue,
    outstandingCredit,
    unpaidInvoicesTotal,
    pendingOrdersCount,
    creditScore,
  ];
}
