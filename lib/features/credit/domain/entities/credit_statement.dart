import 'package:equatable/equatable.dart';
// local imports
import 'package:agrifober_resellers/features/credit/domain/entities/credit_score.dart';

/// What a credit line comes from: a vente sold on credit, a bon sold on
/// credit, or a manual credit Agrifober recorded (a loan, an advance…).
enum CreditItemType { sale, deliveryNote, manual }

class CreditItem extends Equatable {
  final String uid;
  final CreditItemType type;
  final DateTime date;

  /// Set on manual credits only.
  final String designation;
  final double amount;

  /// Still owed on this line (gross: règlements are recorded per client, not
  /// per line — the statement's [CreditStatement.outstanding] is the total due).
  final double remaining;
  final DateTime? dueDate;
  final bool isOverdue;

  /// Supporting document attached to a manual credit, if any.
  final String documentUrl;
  final String documentName;

  const CreditItem({
    required this.uid,
    required this.type,
    required this.date,
    required this.designation,
    required this.amount,
    required this.remaining,
    required this.dueDate,
    required this.isOverdue,
    required this.documentUrl,
    required this.documentName,
  });

  @override
  List<Object?> get props => [
    uid,
    type,
    date,
    designation,
    amount,
    remaining,
    dueDate,
    isOverdue,
    documentUrl,
    documentName,
  ];
}

/// A règlement (repayment) the revendeur made.
class CreditPayment extends Equatable {
  final String uid;
  final DateTime date;
  final double amount;
  final String channel;

  const CreditPayment({
    required this.uid,
    required this.date,
    required this.amount,
    required this.channel,
  });

  @override
  List<Object?> get props => [uid, date, amount, channel];
}

/// The revendeur's credit account: total still owed, what makes it up, and
/// what was paid back.
class CreditStatement extends Equatable {
  final double outstanding;
  final CreditScore creditScore;
  final List<CreditItem> items;
  final List<CreditPayment> payments;

  const CreditStatement({
    required this.outstanding,
    required this.creditScore,
    required this.items,
    required this.payments,
  });

  @override
  List<Object?> get props => [outstanding, creditScore, items, payments];
}
