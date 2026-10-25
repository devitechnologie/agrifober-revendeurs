import 'package:dartz/dartz.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/domain/repositories/index.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<DataState<Unit>> call(String refreshToken) async {
    return await _repository.logout(refreshToken: refreshToken);
  }
}
