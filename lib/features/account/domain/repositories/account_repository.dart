import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/account/domain/entities/index.dart';

abstract class AccountRepository {
  Future<DataState<AccountSummary>> getSummary();
}
