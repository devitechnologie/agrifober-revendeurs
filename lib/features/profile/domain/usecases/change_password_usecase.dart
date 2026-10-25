import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/domain/entities/index.dart';
import 'package:agrifober_resellers/features/profile/domain/repositories/index.dart';

class ChangePasswordUseCase {
  final ProfileRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<DataState<User>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
