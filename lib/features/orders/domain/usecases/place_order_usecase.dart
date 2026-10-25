import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/orders/domain/entities/index.dart';
import 'package:agrifober_resellers/features/orders/domain/repositories/index.dart';

class PlaceOrderUseCase {
  final OrdersRepository _repository;

  PlaceOrderUseCase(this._repository);

  Future<DataState<OrderDetails>> call({
    required List<OrderRequestLine> lines,
    String note = '',
    double creditAmount = 0,
  }) async {
    return await _repository.placeOrder(
      lines: lines,
      note: note.trim(),
      creditAmount: creditAmount < 0 ? 0 : creditAmount,
    );
  }
}
