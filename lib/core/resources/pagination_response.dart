import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/entities/pagination.dart';

part 'pagination_response.freezed.dart';
part 'pagination_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginationResponse<T> with _$PaginationResponse<T> {
  const factory PaginationResponse({
    required List<T> data,
    required Meta meta,
  }) = _PaginationResponse;

  factory PaginationResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) mapper,
  ) => _$PaginationResponseFromJson(json, mapper);
}

@freezed
abstract class Meta with _$Meta {
  const factory Meta({
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'per_page') required int perPage,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}

// Mapping extension
extension PaginationResponseX<T> on PaginationResponse<T> {
  Pagination<E> toEntity<E>({required List<E> entities}) {
    return Pagination<E>(
      data: entities,
      currentPage: meta.currentPage,
      lastPage: meta.lastPage,
      perPage: meta.perPage,
    );
  }
}
