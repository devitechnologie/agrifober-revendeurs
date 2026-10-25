import 'package:equatable/equatable.dart';

/// Drafts never reach the app: a facture is either sent (awaiting payment) or
/// paid.
enum InvoiceStatus { sent, paid }

class Invoice extends Equatable {
  final String uid;
  final DateTime date;
  final DateTime? dueDate;
  final InvoiceStatus status;
  final double total;
  final double amountPaid;

  /// Left to pay on a sent facture; 0 once paid.
  final double outstanding;
  final int linesCount;

  const Invoice({
    required this.uid,
    required this.date,
    required this.dueDate,
    required this.status,
    required this.total,
    required this.amountPaid,
    required this.outstanding,
    required this.linesCount,
  });

  @override
  List<Object?> get props => [
    uid,
    date,
    dueDate,
    status,
    total,
    amountPaid,
    outstanding,
    linesCount,
  ];
}
