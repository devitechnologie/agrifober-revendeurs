import 'dart:async';

import 'package:agrifober_resellers/features/auth/auth.dart';

class AuthEvents {
  static final StreamController<AuthEvent> _controller =
      StreamController<AuthEvent>.broadcast();

  static Stream<AuthEvent> get stream => _controller.stream;

  static void emit(AuthEvent event) {
    _controller.add(event);
  }
}

abstract class AuthEvent {}

class TokenExpiredEvent extends AuthEvent {}

class RefreshEvent extends AuthEvent {}

class AuthenticatedEvent extends AuthEvent {
  final User user;

  AuthenticatedEvent(this.user);
}

/// Also emitted by the network layer after it rotated the tokens, so the
/// in-memory session holds the same pair as local storage.
class UpdateProfileEvent extends AuthEvent {
  final User user;

  UpdateProfileEvent(this.user);
}

class LogOutEvent extends AuthEvent {
  /// True when the server ended the session (expired or revoked refresh token,
  /// access disabled, password reset by the admin) rather than the user.
  final bool sessionExpired;

  LogOutEvent({this.sessionExpired = false});
}
