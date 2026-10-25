import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

/// List item and detail of `/v1/reseller/orders` — the detail (also returned
/// by create and cancel) adds `lines` and `status_history`.
@freezed
abstract class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    @Default('en_attente') String status,
    @Default(0) double total,
    @JsonKey(name: 'credit_amount') @Default(0) double creditAmount,
    @Default('') String note,
    @JsonKey(name: 'refusal_reason') @Default('') String refusalReason,
    @JsonKey(name: 'lines_count') @Default(0) int linesCount,
    @JsonKey(name: 'has_delivery_note') @Default(false) bool hasDeliveryNote,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'updated_at') @Default('') String updatedAt,
    @Default([]) List<DocumentLineModel> lines,
    @JsonKey(name: 'status_history')
    @Default([])
    List<OrderStatusChangeModel> statusHistory,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}

@freezed
abstract class OrderStatusChangeModel with _$OrderStatusChangeModel {
  const factory OrderStatusChangeModel({
    @Default('en_attente') String status,
    @Default('') String at,
  }) = _OrderStatusChangeModel;

  factory OrderStatusChangeModel.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusChangeModelFromJson(json);
}

OrderStatus _statusFromApi(String value) => switch (value) {
  'confirmee' => OrderStatus.confirmed,
  'livree' => OrderStatus.delivered,
  'refusee' => OrderStatus.refused,
  'annulee' => OrderStatus.cancelled,
  _ => OrderStatus.pending,
};

extension OrderModelX on OrderModel {
  Order toEntity() => Order(
    uid: id,
    status: _statusFromApi(status),
    total: total,
    creditAmount: creditAmount,
    note: note,
    refusalReason: refusalReason,
    linesCount: linesCount,
    hasDeliveryNote: hasDeliveryNote,
    createdAt: parseApiDate(createdAt),
    updatedAt: parseApiDate(updatedAt),
  );

  OrderDetails toDetailsEntity() => OrderDetails(
    order: toEntity(),
    lines: lines.map((l) => l.toEntity()).toList(),
    history: statusHistory
        .map(
          (h) => OrderStatusChange(
            status: _statusFromApi(h.status),
            at: parseApiDate(h.at),
          ),
        )
        .toList(),
  );
}
