import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/orders/domain/entities/index.dart';
import 'package:agrifober_resellers/features/orders/domain/repositories/index.dart';

class GetOrdersUseCase {
  final OrdersRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<DataState<Pagination<Order>>> call({int page = 1}) async {
    return await _repository.getOrders(page: page);
  }
}
