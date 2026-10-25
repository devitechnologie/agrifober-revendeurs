import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/sales/domain/entities/index.dart';
import 'package:agrifober_resellers/features/sales/domain/repositories/index.dart';

class GetSalesUseCase {
  final SalesRepository _repository;

  GetSalesUseCase(this._repository);

  Future<DataState<Pagination<Sale>>> call({int page = 1}) async {
    return await _repository.getSales(page: page);
  }
}
