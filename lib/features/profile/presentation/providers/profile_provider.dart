import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/profile/domain/domain.dart';

part 'profile_provider.g.dart';

@riverpod
Future<Profile> profile(Ref ref) async {
  ref.watch(authProvider.select((auth) => auth.value?.uid));
  final result = await ref.read(getProfileUseCaseProvider)();
  return result.when(success: (data) => data, failure: (error) => throw error);
}

@riverpod
class DeleteAccountNotifier extends _$DeleteAccountNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Returns the failure (wrong password → 422 with the API's message) or
  /// null on success, after which the session is closed.
  Future<Failure?> deleteAccount({required String password}) async {
    state = const AsyncValue.loading();
    final result = await ref.read(deleteAccountUseCaseProvider)(
      password: password,
    );

    return result.when<Failure?>(
      success: (_) {
        // The server already revoked every token: just clear the local
        // session, nothing left to revoke.
        AuthEvents.emit(LogOutEvent(sessionExpired: false));
        if (ref.mounted) state = const AsyncValue.data(null);
        return null;
      },
      failure: (error) {
        if (ref.mounted) state = AsyncValue.error(error, StackTrace.current);
        return error;
      },
    );
  }
}

@riverpod
class ChangePasswordNotifier extends _$ChangePasswordNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Returns the failure when the server refused — a wrong current password
  /// comes back as a 422 carrying the API's own message — or null on success.
  /// Every other device is signed out; this one keeps its new tokens.
  Future<Failure?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();

    final result = await ref.read(changePasswordUseCaseProvider)(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result.when<Failure?>(
      success: (user) {
        AuthEvents.emit(UpdateProfileEvent(user));
        if (ref.mounted) state = const AsyncValue.data(null);
        return null;
      },
      failure: (error) {
        if (ref.mounted) state = AsyncValue.error(error, StackTrace.current);
        return error;
      },
    );
  }
}
