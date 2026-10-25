import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/sales/domain/entities/index.dart';

abstract class SalesRepository {
  Future<DataState<Pagination<Sale>>> getSales({
    int page = 1,
    int perPage = 20,
  });

  Future<DataState<SaleDetails>> getSale({required String uid});
}
