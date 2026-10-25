import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/credit/domain/domain.dart';
import 'package:agrifober_resellers/features/credit/data/models/credit_score_model.dart';

part 'credit_statement_model.freezed.dart';
part 'credit_statement_model.g.dart';

@freezed
abstract class CreditStatementModel with _$CreditStatementModel {
  const factory CreditStatementModel({
    @Default(0) double outstanding,
    @JsonKey(name: 'credit_score') CreditScoreModel? creditScore,
    @Default([]) List<CreditItemModel> items,
    @Default([]) List<CreditPaymentModel> payments,
  }) = _CreditStatementModel;

  factory CreditStatementModel.fromJson(Map<String, dynamic> json) =>
      _$CreditStatementModelFromJson(json);
}

@freezed
abstract class CreditItemModel with _$CreditItemModel {
  const factory CreditItemModel({
    required String id,
    @Default('manual') String type,
    @Default('') String date,
    @Default('') String designation,
    @Default(0) double amount,
    @Default(0) double remaining,
    @JsonKey(name: 'due_date') @Default('') String dueDate,
    @JsonKey(name: 'is_overdue') @Default(false) bool isOverdue,
    @JsonKey(name: 'document_url') @Default('') String documentUrl,
    @JsonKey(name: 'document_name') @Default('') String documentName,
  }) = _CreditItemModel;

  factory CreditItemModel.fromJson(Map<String, dynamic> json) =>
      _$CreditItemModelFromJson(json);
}

@freezed
abstract class CreditPaymentModel with _$CreditPaymentModel {
  const factory CreditPaymentModel({
    required String id,
    @Default('') String date,
    @Default(0) double amount,
    @Default('') String channel,
  }) = _CreditPaymentModel;

  factory CreditPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$CreditPaymentModelFromJson(json);
}

extension CreditStatementModelX on CreditStatementModel {
  CreditStatement toEntity() => CreditStatement(
    outstanding: outstanding,
    creditScore: creditScore.toEntityOrEmpty(),
    items: items.map((i) => i.toEntity()).toList(),
    payments: payments.map((p) => p.toEntity()).toList(),
  );
}

extension CreditItemModelX on CreditItemModel {
  CreditItem toEntity() => CreditItem(
    uid: id,
    type: switch (type) {
      'sale' => CreditItemType.sale,
      'delivery_note' => CreditItemType.deliveryNote,
      _ => CreditItemType.manual,
    },
    date: parseApiDate(date),
    designation: designation,
    amount: amount,
    remaining: remaining,
    dueDate: parseOptionalApiDate(dueDate),
    isOverdue: isOverdue,
    documentUrl: documentUrl,
    documentName: documentName,
  );
}

extension CreditPaymentModelX on CreditPaymentModel {
  CreditPayment toEntity() => CreditPayment(
    uid: id,
    date: parseApiDate(date),
    amount: amount,
    channel: channel,
  );
}
