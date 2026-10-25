import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/credit/domain/entities/index.dart';
import 'package:agrifober_resellers/features/credit/domain/repositories/index.dart';

class GetCreditStatementUseCase {
  final CreditRepository _repository;

  GetCreditStatementUseCase(this._repository);

  Future<DataState<CreditStatement>> call() async {
    return await _repository.getStatement();
  }
}
