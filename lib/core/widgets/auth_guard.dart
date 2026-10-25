import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local imports
import 'package:agrifober_resellers/core/events/index.dart';
import 'package:agrifober_resellers/core/utils/app_logger.dart';
import 'package:agrifober_resellers/core/providers/index.dart';

class AuthGuard extends ConsumerStatefulWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  ConsumerState<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends ConsumerState<AuthGuard> {
  late StreamSubscription<AuthEvent> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = AuthEvents.stream.listen(_handleAuthEvent);
  }

  void _handleAuthEvent(AuthEvent event) {
    if (!mounted) return;
    _performNavigation(event);
  }

  void _performNavigation(AuthEvent event) {
    final authNotifier = ref.read(authProvider.notifier);

    try {
      if (event is TokenExpiredEvent) {
        authNotifier.refreshExpiredToken(
          onError: (error) {
            authNotifier.logout(sessionExpired: true);
          },
        );
      } else if (event is AuthenticatedEvent) {
        authNotifier.login(event.user);
      } else if (event is UpdateProfileEvent) {
        authNotifier.updateCurrentUser(event.user);
      } else if (event is RefreshEvent) {
        authNotifier.refreshExpiredToken(
          onError: (error) {
            authNotifier.logout(sessionExpired: true);
          },
        );
      } else if (event is LogOutEvent) {
        authNotifier.logout(sessionExpired: event.sessionExpired);
      }
    } catch (e) {
      logger.e('[AuthGuard] Error handling auth event: $e');
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
