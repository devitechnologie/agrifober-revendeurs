import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/features/account/domain/domain.dart';
import 'package:agrifober_resellers/features/credit/data/models/credit_score_model.dart';

part 'account_summary_model.freezed.dart';
part 'account_summary_model.g.dart';

@freezed
abstract class AccountSummaryModel with _$AccountSummaryModel {
  const factory AccountSummaryModel({
    @JsonKey(name: 'sales_count') @Default(0) int salesCount,
    @JsonKey(name: 'delivery_notes_count') @Default(0) int deliveryNotesCount,
    @Default(0) double revenue,
    @JsonKey(name: 'outstanding_credit') @Default(0) double outstandingCredit,
    @JsonKey(name: 'unpaid_invoices_total')
    @Default(0)
    double unpaidInvoicesTotal,
    @JsonKey(name: 'pending_orders_count') @Default(0) int pendingOrdersCount,
    @JsonKey(name: 'credit_score') CreditScoreModel? creditScore,
  }) = _AccountSummaryModel;

  factory AccountSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$AccountSummaryModelFromJson(json);
}

extension AccountSummaryModelX on AccountSummaryModel {
  AccountSummary toEntity() => AccountSummary(
    salesCount: salesCount,
    deliveryNotesCount: deliveryNotesCount,
    revenue: revenue,
    outstandingCredit: outstandingCredit,
    unpaidInvoicesTotal: unpaidInvoicesTotal,
    pendingOrdersCount: pendingOrdersCount,
    creditScore: creditScore.toEntityOrEmpty(),
  );
}
