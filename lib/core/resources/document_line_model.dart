import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/entities/document_line.dart';

part 'document_line_model.freezed.dart';
part 'document_line_model.g.dart';

/// `lines[]` item shared by the sales, delivery notes and orders endpoints.
@freezed
abstract class DocumentLineModel with _$DocumentLineModel {
  const factory DocumentLineModel({
    @JsonKey(name: 'product_id') @Default('') String productId,
    @Default('') String designation,
    @Default(0) double qty,
    @JsonKey(name: 'unit_price') @Default(0) double unitPrice,
    @Default(0) double total,
  }) = _DocumentLineModel;

  factory DocumentLineModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentLineModelFromJson(json);
}

extension DocumentLineModelX on DocumentLineModel {
  DocumentLine toEntity() => DocumentLine(
    productUid: productId,
    designation: designation,
    qty: qty,
    unitPrice: unitPrice,
    total: total,
  );
}

/// `"cash"` / `"credit"` / `""` → [PaymentMethod].
PaymentMethod paymentMethodFromApi(String value) => switch (value) {
  'cash' => PaymentMethod.cash,
  'credit' => PaymentMethod.credit,
  _ => PaymentMethod.none,
};
