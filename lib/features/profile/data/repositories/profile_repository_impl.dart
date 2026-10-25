import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/auth.dart';
import 'package:agrifober_resellers/features/profile/data/datasources/index.dart';
import 'package:agrifober_resellers/features/profile/data/models/index.dart';
import 'package:agrifober_resellers/features/profile/domain/domain.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService _apiService;

  ProfileRepositoryImpl({required ProfileApiService apiService})
    : _apiService = apiService;

  @override
  Future<DataState<Profile>> getProfile() async {
    try {
      final response = await _apiService.getProfile();
      return DataState.success(data: response.data.toEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<DataState<Unit>> deleteAccount({required String password}) async {
    try {
      await _apiService.deleteAccount({"password": password});
      return DataState.success(data: unit);
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }

  @override
  Future<DataState<User>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.changePassword({
        "current_password": currentPassword,
        "new_password": newPassword,
      });
      return DataState.success(data: response.toEntity());
    } on DioException catch (e) {
      return DataState.failure(error: handleDioError(e));
    } catch (e) {
      return DataState.failure(error: ServerFailure("Unexpected error: $e"));
    }
  }
}
