import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/sales/domain/entities/index.dart';
import 'package:agrifober_resellers/features/sales/domain/repositories/index.dart';

class GetSaleUseCase {
  final SalesRepository _repository;

  GetSaleUseCase(this._repository);

  Future<DataState<SaleDetails>> call(String uid) async {
    return await _repository.getSale(uid: uid);
  }
}
