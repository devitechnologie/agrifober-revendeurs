import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/domain.dart';

part 'delivery_note_model.freezed.dart';
part 'delivery_note_model.g.dart';

/// List item and detail of `GET /v1/reseller/delivery-notes[/{id}]` — the
/// detail only adds `subtotal`, `discount` and `lines`.
@freezed
abstract class DeliveryNoteModel with _$DeliveryNoteModel {
  const factory DeliveryNoteModel({
    required String id,
    @Default('') String date,
    @JsonKey(name: 'point_of_sale') @Default('') String pointOfSale,
    @JsonKey(name: 'lines_count') @Default(0) int linesCount,
    @Default(0) double total,
    @JsonKey(name: 'payment_method') @Default('') String paymentMethod,
    @JsonKey(name: 'amount_paid') @Default(0) double amountPaid,
    @Default(0) double remaining,
    @Default(0) double subtotal,
    @Default(0) double discount,
    @Default([]) List<DocumentLineModel> lines,
  }) = _DeliveryNoteModel;

  factory DeliveryNoteModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryNoteModelFromJson(json);
}

extension DeliveryNoteModelX on DeliveryNoteModel {
  DeliveryNote toEntity() => DeliveryNote(
    uid: id,
    date: parseApiDate(date),
    pointOfSale: pointOfSale,
    linesCount: linesCount,
    total: total,
    paymentMethod: paymentMethodFromApi(paymentMethod),
    amountPaid: amountPaid,
    remaining: remaining,
  );

  DeliveryNoteDetails toDetailsEntity() => DeliveryNoteDetails(
    deliveryNote: toEntity(),
    subtotal: subtotal,
    discount: discount,
    lines: lines.map((l) => l.toEntity()).toList(),
  );
}
