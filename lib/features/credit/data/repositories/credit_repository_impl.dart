import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/credit/data/datasources/index.dart';
import 'package:agrifober_resellers/features/credit/data/models/index.dart';
import 'package:agrifober_resellers/features/credit/domain/domain.dart';

class CreditRepositoryImpl implements CreditRepository {
  final CreditApiService _apiService;

  CreditRepositoryImpl({required CreditApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<CreditStatement>> getStatement() async {
    try {
      final response = await _apiService.getStatement();
      return DataState.success(data: response.data.toEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }
}
