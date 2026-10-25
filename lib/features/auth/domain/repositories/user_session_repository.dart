import 'package:dartz/dartz.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/domain/entities/index.dart';

abstract class UserSessionRepository {
  Future<DataState<User>> getUser();
  Future<DataState<Unit>> saveUser(User user);
  Future<DataState<Unit>> clearUser();
}
