import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/orders/domain/entities/index.dart';

abstract class OrdersRepository {
  Future<DataState<Pagination<Order>>> getOrders({
    int page = 1,
    int perPage = 20,
  });

  Future<DataState<OrderDetails>> getOrder({required String uid});

  /// [creditAmount]: part of the total to pay on credit (score crédit).
  Future<DataState<OrderDetails>> placeOrder({
    required List<OrderRequestLine> lines,
    required String note,
    double creditAmount = 0,
  });

  Future<DataState<OrderDetails>> cancelOrder({required String uid});
}
