import 'package:dartz/dartz.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/profile/domain/repositories/index.dart';

class DeleteAccountUseCase {
  final ProfileRepository _repository;

  DeleteAccountUseCase(this._repository);

  Future<DataState<Unit>> call({required String password}) async {
    return await _repository.deleteAccount(password: password);
  }
}
