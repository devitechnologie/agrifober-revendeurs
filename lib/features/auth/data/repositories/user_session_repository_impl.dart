import 'package:dartz/dartz.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/data/datasources/index.dart';
import 'package:agrifober_resellers/features/auth/data/models/index.dart';
import 'package:agrifober_resellers/features/auth/domain/domain.dart';

class UserSessionRepositoryImpl implements UserSessionRepository {
  final AuthLocalService _localDataSource;

  UserSessionRepositoryImpl({required AuthLocalService localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<DataState<Unit>> saveUser(User user) async {
    try {
      await _localDataSource.saveUser(user.toModel());
      return const DataState.success(data: unit);
    } catch (e) {
      return DataState.failure(error: StorageFailure(e.toString()));
    }
  }

  @override
  Future<DataState<User>> getUser() async {
    try {
      final authUser = await _localDataSource.getUser();
      if (authUser != null) {
        return DataState.success(data: authUser.toEntity());
      } else {
        return DataState.failure(error: CacheFailure('No user found'));
      }
    } catch (e) {
      return DataState.failure(error: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<DataState<Unit>> clearUser() async {
    try {
      await _localDataSource.clearUser();
      return const DataState.success(data: unit);
    } catch (e) {
      return DataState.failure(error: StorageFailure(e.toString()));
    }
  }
}
