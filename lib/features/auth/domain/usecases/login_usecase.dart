import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/domain/entities/index.dart';
import 'package:agrifober_resellers/features/auth/domain/repositories/index.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<DataState<User>> call(PhoneNumber phone, String password) async {
    return await _repository.login(phone: phone, password: password);
  }
}
