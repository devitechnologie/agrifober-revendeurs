import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/account/data/datasources/index.dart';
import 'package:agrifober_resellers/features/account/data/models/index.dart';
import 'package:agrifober_resellers/features/account/domain/domain.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountApiService _apiService;

  AccountRepositoryImpl({required AccountApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<AccountSummary>> getSummary() async {
    try {
      final response = await _apiService.getSummary();
      return DataState.success(data: response.data.toEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }
}
