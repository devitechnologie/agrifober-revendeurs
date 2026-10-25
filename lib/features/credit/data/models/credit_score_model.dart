import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/features/credit/domain/entities/credit_score.dart';

part 'credit_score_model.freezed.dart';
part 'credit_score_model.g.dart';

/// `credit_score` block of `/summary` and `/credit`.
@freezed
abstract class CreditScoreModel with _$CreditScoreModel {
  const factory CreditScoreModel({
    @Default(0) double score,
    @Default(0) double outstanding,
    @Default(0) double pending,
    @Default(0) double available,
  }) = _CreditScoreModel;

  factory CreditScoreModel.fromJson(Map<String, dynamic> json) =>
      _$CreditScoreModelFromJson(json);
}

extension CreditScoreModelX on CreditScoreModel {
  CreditScore toEntity() => CreditScore(
    score: score,
    outstanding: outstanding,
    pending: pending,
    available: available,
  );
}

/// Older API builds don't send the block: no score yet.
extension NullableCreditScoreModelX on CreditScoreModel? {
  CreditScore toEntityOrEmpty() => this?.toEntity() ?? CreditScore.empty;
}
