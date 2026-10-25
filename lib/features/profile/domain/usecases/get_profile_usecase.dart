import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/profile/domain/entities/index.dart';
import 'package:agrifober_resellers/features/profile/domain/repositories/index.dart';

class GetProfileUseCase {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<DataState<Profile>> call() async {
    return await _repository.getProfile();
  }
}
