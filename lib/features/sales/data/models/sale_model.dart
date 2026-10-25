import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/sales/domain/domain.dart';

part 'sale_model.freezed.dart';
part 'sale_model.g.dart';

/// List item and detail of `GET /v1/reseller/sales[/{id}]` — the detail only
/// adds `subtotal`, `discount`, `delivery_price` and `lines`.
@freezed
abstract class SaleModel with _$SaleModel {
  const factory SaleModel({
    required String id,
    @Default('') String date,
    @JsonKey(name: 'sale_type') @Default('magasin') String saleType,
    @JsonKey(name: 'point_of_sale') @Default('') String pointOfSale,
    @JsonKey(name: 'lines_count') @Default(0) int linesCount,
    @Default(0) double total,
    @JsonKey(name: 'payment_method') @Default('') String paymentMethod,
    @JsonKey(name: 'amount_paid') @Default(0) double amountPaid,
    @Default(0) double remaining,
    @JsonKey(name: 'due_date') @Default('') String dueDate,
    @JsonKey(name: 'is_overdue') @Default(false) bool isOverdue,
    @Default(0) double subtotal,
    @Default(0) double discount,
    @JsonKey(name: 'delivery_price') @Default(0) double deliveryPrice,
    @Default([]) List<DocumentLineModel> lines,
  }) = _SaleModel;

  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);
}

extension SaleModelX on SaleModel {
  Sale toEntity() => Sale(
    uid: id,
    date: parseApiDate(date),
    type: switch (saleType) {
      'ferme' => SaleType.farm,
      'ecom' => SaleType.online,
      _ => SaleType.store,
    },
    pointOfSale: pointOfSale,
    linesCount: linesCount,
    total: total,
    paymentMethod: paymentMethodFromApi(paymentMethod),
    amountPaid: amountPaid,
    remaining: remaining,
    dueDate: parseOptionalApiDate(dueDate),
    isOverdue: isOverdue,
  );

  SaleDetails toDetailsEntity() => SaleDetails(
    sale: toEntity(),
    subtotal: subtotal,
    discount: discount,
    deliveryPrice: deliveryPrice,
    lines: lines.map((l) => l.toEntity()).toList(),
  );
}
