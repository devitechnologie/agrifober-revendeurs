import 'package:dartz/dartz.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/domain/entities/index.dart';
import 'package:agrifober_resellers/features/profile/domain/entities/index.dart';

abstract class ProfileRepository {
  /// Erases the revendeur's app access (password + sessions). Their commercial
  /// history stays with Agrifober.
  Future<DataState<Unit>> deleteAccount({required String password});

  Future<DataState<Profile>> getProfile();

  /// Signs every other device out; returns the session with the new tokens
  /// for this one.
  Future<DataState<User>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
