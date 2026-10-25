import 'package:dartz/dartz.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/domain/entities/index.dart';

abstract class AuthRepository {
  /// Phone + password today; an OTP step will replace the password later.
  Future<DataState<User>> login({
    required PhoneNumber phone,
    required String password,
  });

  Future<DataState<User>> refreshToken({required String refreshToken});

  /// Revokes this device's refresh token on the server.
  Future<DataState<Unit>> logout({required String refreshToken});
}
