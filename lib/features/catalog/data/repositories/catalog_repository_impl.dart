import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/catalog/data/datasources/index.dart';
import 'package:agrifober_resellers/features/catalog/data/models/index.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogApiService _apiService;

  CatalogRepositoryImpl({required CatalogApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<Catalog>> getCatalog({bool guest = false}) async {
    try {
      final response = guest
          ? await _apiService.getPublicCatalog()
          : await _apiService.getCatalog();
      return DataState.success(
        data: response.data.toEntity(pricesVisible: !guest),
      );
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }
}
