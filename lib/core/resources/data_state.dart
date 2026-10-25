import 'package:freezed_annotation/freezed_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/error/index.dart';

part 'data_state.freezed.dart';

@freezed
abstract class DataState<T> with _$DataState<T> {
  const factory DataState.success({required T data}) = DataSuccess<T>;
  const factory DataState.failure({required Failure error}) = DataFailure<T>;
}
