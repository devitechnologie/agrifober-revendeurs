import 'package:freezed_annotation/freezed_annotation.dart';

part 'standard_response.freezed.dart';
part 'standard_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class StandardResponse<T> with _$StandardResponse<T> {
  const factory StandardResponse({
    bool? success,
    String? message,
    required T data,
  }) = _StandardResponse;

  factory StandardResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) mapper,
  ) => _$StandardResponseFromJson(json, mapper);
}
