import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/invoices/domain/domain.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
abstract class InvoiceModel with _$InvoiceModel {
  const factory InvoiceModel({
    required String id,
    @Default('') String date,
    @JsonKey(name: 'due_date') @Default('') String dueDate,
    @Default('envoyee') String status,
    @Default(0) double total,
    @JsonKey(name: 'amount_paid') @Default(0) double amountPaid,
    @Default(0) double outstanding,
    @JsonKey(name: 'lines_count') @Default(0) int linesCount,
  }) = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);
}

extension InvoiceModelX on InvoiceModel {
  Invoice toEntity() => Invoice(
    uid: id,
    date: parseApiDate(date),
    dueDate: parseOptionalApiDate(dueDate),
    status: status == 'payee' ? InvoiceStatus.paid : InvoiceStatus.sent,
    total: total,
    amountPaid: amountPaid,
    outstanding: outstanding,
    linesCount: linesCount,
  );
}
