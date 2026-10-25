import 'package:dio/dio.dart';
// local imports
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/features/auth/auth.dart';

const _loginPath = '/v1/reseller/auth/login';
const _refreshPath = '/v1/reseller/auth/refresh';
const _retriedKey = 'auth_retried';

class ApiClient {
  static late Dio _dio;

  static Dio createDio() {
    _dio = Dio(_baseOptions());

    final authLocalService = AuthLocalService();
    _dio.interceptors.add(_AuthInterceptor(authLocalService, _dio));

    return _dio;
  }

  static Dio get dio => _dio;

  static BaseOptions _baseOptions() => BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {"Accept": "application/json"},
  );
}

bool _isAuthEndpoint(String path) =>
    path.contains(_loginPath) || path.contains(_refreshPath);

/// Attaches the bearer token and, on a 401, refreshes the session once and
/// replays the request.
///
/// A [QueuedInterceptor] on purpose: refresh tokens are single-use, so when
/// several requests fail with 401 together only the first may refresh — the
/// others wait, see the rotated token in storage and simply replay.
class _AuthInterceptor extends QueuedInterceptor {
  final AuthLocalService authLocalService;
  final Dio dio;

  _AuthInterceptor(this.authLocalService, this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // The refresh and login endpoints authenticate with their body.
      if (_isAuthEndpoint(options.path)) {
        handler.next(options);
        return;
      }

      final user = await authLocalService.getUser();
      if (user != null) {
        options.headers['Authorization'] = 'Bearer ${user.meta.token}';
      }
    } catch (e) {
      logger.e('Error reading auth token: $e');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    if (err.response?.statusCode != 401 ||
        _isAuthEndpoint(options.path) ||
        options.extra[_retriedKey] == true) {
      handler.next(err);
      return;
    }

    try {
      final stored = await authLocalService.getUser();
      if (stored == null) {
        handler.next(err);
        return;
      }

      var token = stored.meta.token;
      final sentToken = options.headers['Authorization'];
      // Another request already rotated the tokens while this one was queued.
      if (sentToken != 'Bearer $token') {
        handler.resolve(await _replay(options, token));
        return;
      }

      final refreshed = await _sharedRefresh(stored.meta.refreshToken);
      if (refreshed == null) {
        // Refused, but another client may have rotated the pair meanwhile:
        // its fresh token is the one to use, the session is fine.
        final latest = await authLocalService.getUser();
        if (latest != null && latest.meta.token != token) {
          handler.resolve(await _replay(options, latest.meta.token));
          return;
        }
        await authLocalService.clearUser();
        AuthEvents.emit(LogOutEvent(sessionExpired: true));
        handler.next(err);
        return;
      }

      token = refreshed.meta.token;
      handler.resolve(await _replay(options, token));
    } on DioException catch (e) {
      handler.next(e);
    } catch (e) {
      logger.e('[AuthInterceptor] refresh failed: $e');
      handler.next(err);
    }
  }

  /// Refresh shared by every interceptor instance: callers arriving while one
  /// is in flight await it instead of spending the same single-use token.
  static Future<AuthUserModel?>? _inFlight;

  Future<AuthUserModel?> _sharedRefresh(String refreshToken) {
    return _inFlight ??= () async {
      try {
        final refreshed = await _refresh(refreshToken);
        if (refreshed != null) {
          await authLocalService.saveUser(refreshed);
          AuthEvents.emit(UpdateProfileEvent(refreshed.toEntity()));
        }
        return refreshed;
      } finally {
        _inFlight = null;
      }
    }();
  }

  /// Null when the server refuses the refresh token (expired, already used,
  /// or the session was revoked).
  Future<AuthUserModel?> _refresh(String refreshToken) async {
    try {
      // A bare client: going through [dio] would queue behind this very call.
      final response = await Dio(ApiClient._baseOptions())
          .post<Map<String, dynamic>>(
            _refreshPath,
            data: {'refresh_token': refreshToken},
          );
      return AuthUserModel.fromJson(response.data!);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 422) return null;
      rethrow;
    }
  }

  Future<Response<dynamic>> _replay(RequestOptions options, String token) {
    options.headers['Authorization'] = 'Bearer $token';
    options.extra[_retriedKey] = true;
    return dio.fetch<dynamic>(options);
  }
}

