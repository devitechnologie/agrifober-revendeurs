import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/orders/data/datasources/index.dart';
import 'package:agrifober_resellers/features/orders/data/models/index.dart';
import 'package:agrifober_resellers/features/orders/domain/domain.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersApiService _apiService;

  OrdersRepositoryImpl({required OrdersApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<Pagination<Order>>> getOrders({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _apiService.getOrders(
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
  Future<DataState<OrderDetails>> getOrder({required String uid}) async {
    try {
      final response = await _apiService.getOrder(uid);
      return DataState.success(data: response.data.toDetailsEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<DataState<OrderDetails>> placeOrder({
    required List<OrderRequestLine> lines,
    required String note,
    double creditAmount = 0,
  }) async {
    try {
      final response = await _apiService.placeOrder({
        "lines": lines
            .map((l) => {"product_id": l.productUid, "qty": l.qty})
            .toList(),
        "note": note,
        if (creditAmount > 0) "credit_amount": creditAmount,
      });
      return DataState.success(data: response.data.toDetailsEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<DataState<OrderDetails>> cancelOrder({required String uid}) async {
    try {
      final response = await _apiService.cancelOrder(uid);
      return DataState.success(data: response.data.toDetailsEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }
}
