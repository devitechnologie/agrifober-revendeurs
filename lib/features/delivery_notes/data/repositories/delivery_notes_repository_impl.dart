import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/delivery_notes/data/datasources/index.dart';
import 'package:agrifober_resellers/features/delivery_notes/data/models/index.dart';
import 'package:agrifober_resellers/features/delivery_notes/domain/domain.dart';

class DeliveryNotesRepositoryImpl implements DeliveryNotesRepository {
  final DeliveryNotesApiService _apiService;

  DeliveryNotesRepositoryImpl({required DeliveryNotesApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<Pagination<DeliveryNote>>> getDeliveryNotes({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _apiService.getDeliveryNotes(
        page: page,
        perPage: perPage,
      );
      return DataState.success(
        data: response.toEntity(
          entities: response.data.map((m) => m.toEntity()).toList(),
        ),
      );
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<DataState<DeliveryNoteDetails>> getDeliveryNote({
    required String uid,
  }) async {
    try {
      final response = await _apiService.getDeliveryNote(uid);
      return DataState.success(data: response.data.toDetailsEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }
}
