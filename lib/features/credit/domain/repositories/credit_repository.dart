import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/credit/domain/entities/index.dart';

abstract class CreditRepository {
  Future<DataState<CreditStatement>> getStatement();
}
