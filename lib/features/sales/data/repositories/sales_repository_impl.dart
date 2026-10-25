import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/sales/data/datasources/index.dart';
import 'package:agrifober_resellers/features/sales/data/models/index.dart';
import 'package:agrifober_resellers/features/sales/domain/domain.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesApiService _apiService;

  SalesRepositoryImpl({required SalesApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<Pagination<Sale>>> getSales({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _apiService.getSales(page: page, perPage: perPage);
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
  Future<DataState<SaleDetails>> getSale({required String uid}) async {
    try {
      final response = await _apiService.getSale(uid);
      return DataState.success(data: response.data.toDetailsEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }
}
