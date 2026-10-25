import 'package:riverpod_annotation/riverpod_annotation.dart';
// local imports
import 'package:agrifober_resellers/core/utils/app_logger.dart';
import 'package:agrifober_resellers/core/di/providers.dart';
import 'package:agrifober_resellers/core/resources/index.dart';
import 'package:agrifober_resellers/features/auth/auth.dart';
import 'package:agrifober_resellers/core/error/index.dart';

part 'auth_provider.g.dart';

// Holds the last known non-null User so currentUserProvider can return a
// valid value during the single-frame window between logout() setting auth
// state to null and the router redirecting away from authenticated screens.
User? _userCache;

// Refresh tokens are single-use: concurrent callers share one refresh.
Future<void>? _refreshInFlight;

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() {
    _checkAuthStatus();
    return const AsyncValue.loading();
  }

  // No refresh here: the network layer refreshes the session on the first 401,
  // so a stored session is used as is and an expired one recovers on demand.
  Future<void> _checkAuthStatus() async {
    try {
      final userSessionRepository = ref.read(userSessionRepositoryProvider);
      final result = await userSessionRepository.getUser();

      result.when(
        success: (user) {
          if (!ref.mounted) return;
          _userCache = user;
          state = AsyncValue.data(user);
        },
        failure: (_) {
          if (!ref.mounted) return;
          state = const AsyncValue.data(null);
        },
      );
    } catch (e) {
      if (!ref.mounted) return;
      state = const AsyncValue.data(null);
    }
  }

  void setUser(User user) {
    _userCache = user;
    state = AsyncValue.data(user);
  }

  void refreshExpiredToken({
    Function? onSuccess,
    Function(Failure error)? onError,
  }) async {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      await inFlight;
      onSuccess?.call();
      return;
    }

    final currentUser = state.value;
    if (currentUser == null) return;

    final refresh = () async {
      final userRepository = ref.read(authRepositoryProvider);
      final tokensData = await userRepository.refreshToken(
        refreshToken: currentUser.tokens.refreshToken,
      );
      await tokensData.when(
        success: (updatedUser) async {
          final userSessionRepository = ref.read(userSessionRepositoryProvider);
          await userSessionRepository.saveUser(updatedUser);
          setUser(updatedUser);
          onSuccess?.call();
        },
        failure: (error) async {
          logger.e('Failed to refresh token', error: error);
          onError?.call(error);
        },
      );
    }();

    _refreshInFlight = refresh;
    try {
      await refresh;
    } finally {
      _refreshInFlight = null;
    }
  }

  /// [sessionExpired]: the server ended the session — the login screen then
  /// explains why the user was signed out, and there is no token to revoke.
  Future<void> logout({bool sessionExpired = false}) async {
    final refreshToken = state.value?.tokens.refreshToken;
    try {
      if (!sessionExpired && refreshToken != null) {
        // Best effort: the local session is cleared whatever the answer.
        ref.read(logoutUseCaseProvider)(refreshToken);
      }
      final userSessionRepository = ref.read(userSessionRepositoryProvider);
      await userSessionRepository.clearUser();
    } catch (e) {
      logger.e('Failed to clear session', error: e);
    }
    if (!ref.mounted) return;
    ref.read(sessionExpiredProvider.notifier).set(sessionExpired);
    state = const AsyncValue.data(null);
  }

  void updateCurrentUser(User user) {
    final userSessionRepository = ref.read(userSessionRepositoryProvider);
    userSessionRepository.saveUser(user);
    _userCache = user;
    state = AsyncValue.data(user);
  }

  Future<void> login(User user) async {
    _userCache = user;
    ref.read(sessionExpiredProvider.notifier).set(false);
    state = AsyncValue.data(user);
    final userSessionRepository = ref.read(userSessionRepositoryProvider);
    await userSessionRepository.saveUser(user);
  }
}

/// True after the server ended the session, until the next sign-in: the login
/// screen shows "Votre session a expiré" while it is set.
@Riverpod(keepAlive: true)
class SessionExpiredNotifier extends _$SessionExpiredNotifier {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

@riverpod
User currentUser(Ref ref) {
  final authState = ref.watch(authProvider);

  return authState.when(
    loading: () => throw Exception('Authentication loading'),
    error: (error, stack) => throw error,
    data: (user) {
      if (user != null) return user;
      // Auth state is null (logging out) but the router hasn't redirected yet.
      // Return the cached user so widgets don't throw a ProviderException
      // during this single-frame transition window.
      final cached = _userCache;
      if (cached != null) return cached;
      throw Exception('User not authenticated');
    },
  );
}
