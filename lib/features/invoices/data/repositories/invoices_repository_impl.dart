import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/invoices/data/datasources/index.dart';
import 'package:agrifober_resellers/features/invoices/data/models/index.dart';
import 'package:agrifober_resellers/features/invoices/domain/domain.dart';

class InvoicesRepositoryImpl implements InvoicesRepository {
  final InvoicesApiService _apiService;

  InvoicesRepositoryImpl({required InvoicesApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<Pagination<Invoice>>> getInvoices({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _apiService.getInvoices(
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
}
