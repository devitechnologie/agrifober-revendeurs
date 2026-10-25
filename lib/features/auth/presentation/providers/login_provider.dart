import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/domain/domain.dart';

part 'login_provider.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AsyncValue<User?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> login(PhoneNumber phone, String password) async {
    state = const AsyncValue.loading();
    final loginUseCase = ref.read(loginUseCaseProvider);
    final user = await loginUseCase(phone, password);

    user.when(
      success: (user) {
        AuthEvents.emit(AuthenticatedEvent(user));
        state = AsyncValue.data(user);
      },
      failure: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  void resetError() {
    if (state.hasError) {
      state = const AsyncValue.data(null);
    }
  }
}
