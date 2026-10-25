import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/orders/domain/entities/index.dart';
import 'package:agrifober_resellers/features/orders/domain/repositories/index.dart';

class CancelOrderUseCase {
  final OrdersRepository _repository;

  CancelOrderUseCase(this._repository);

  Future<DataState<OrderDetails>> call(String uid) async {
    return await _repository.cancelOrder(uid: uid);
  }
}
