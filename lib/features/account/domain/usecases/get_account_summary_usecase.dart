import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/account/domain/entities/index.dart';
import 'package:agrifober_resellers/features/account/domain/repositories/index.dart';

class GetAccountSummaryUseCase {
  final AccountRepository _repository;

  GetAccountSummaryUseCase(this._repository);

  Future<DataState<AccountSummary>> call() async {
    return await _repository.getSummary();
  }
}
