import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// local import
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/config/router/app_routes.dart';
import 'package:agrifober_resellers/config/router/transitions/cupertino_transition.dart';
import 'package:agrifober_resellers/modules/history/history.dart';
import 'package:agrifober_resellers/modules/home/home.dart';
import 'package:agrifober_resellers/features/auth/auth.dart';
import 'package:agrifober_resellers/features/catalog/catalog.dart';
import 'package:agrifober_resellers/features/credit/credit.dart';
import 'package:agrifober_resellers/features/delivery_notes/delivery_notes.dart';
import 'package:agrifober_resellers/features/orders/orders.dart';
import 'package:agrifober_resellers/features/profile/profile.dart';
import 'package:agrifober_resellers/features/sales/sales.dart';

class AuthChangeNotifier extends ChangeNotifier {
  final WidgetRef ref;

  AuthChangeNotifier(this.ref) {
    ref.listen(authProvider, (_, _) {
      notifyListeners();
    });
  }
}

class GoRouterSetup {
  // Private navigator key
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter createRouter(WidgetRef ref) {
    return GoRouter(
      initialLocation: Routes.splash.path,
      navigatorKey: _navigatorKey,
      refreshListenable: AuthChangeNotifier(ref),
      // Guest mode is the catalogue only (/browse and /product/:uid, without
      // prices); every other screen needs a signed-in revendeur.
      redirect: (context, state) {
        final authState = ref.read(authProvider);
        final currentLocation = state.matchedLocation;

        if (authState.isLoading) {
          return Routes.splash.route;
        }

        if (authState.hasError) {
          logger.e('Authentication error: ${authState.error}');
          return Routes.login.route;
        }

        final isAuthenticated = authState.value != null;
        final isPublicRoute = _isPublicRoutes(currentLocation);

        if (!isAuthenticated) {
          if (currentLocation == Routes.login.route) return null;
          if (_isGuestRoutes(currentLocation)) return null;
          return isPublicRoute
              ? Routes.login.route
              : _loginWithTarget(state.uri.toString());
        }

        // Signed in, the guest catalogue becomes the real one.
        if (currentLocation == Routes.browse.route) {
          return Routes.catalog.route;
        }

        // Signed in: splash and login have nothing left to show. Coming from
        // login, continue to the page that sent the user there.
        if (isPublicRoute) {
          final target = state.uri.queryParameters['from'];
          return target != null && target.startsWith('/')
              ? target
              : Routes.home.route;
        }
        return null;
      },
      routes: <RouteBase>[
        ShellRoute(
          builder: (context, state, child) {
            return AuthGuard(child: child);
          },
          routes: <RouteBase>[
            StatefulShellRoute.indexedStack(
              pageBuilder: (context, state, navigationShell) {
                return buildPageWithCupertinoTransition(
                  context: context,
                  state: state,
                  child: PopScopeWrapper(
                    child: CustomBottomAppBar(navShell: navigationShell),
                  ),
                );
              },
              branches: <StatefulShellBranch>[
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.home.path,
                      builder: (context, state) {
                        return HomeScreen(key: state.pageKey);
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.catalog.path,
                      builder: (context, state) {
                        return CatalogScreen(key: state.pageKey);
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.history.path,
                      builder: (context, state) {
                        return HistoryScreen(
                          key: state.pageKey,
                          initialTab: HistoryTab.fromQuery(
                            state.uri.queryParameters[Routes
                                .historyTabQueryKey],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.credit.path,
                      builder: (context, state) {
                        return CreditScreen(key: state.pageKey);
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.profile.path,
                      builder: (context, state) {
                        return ProfileScreen(key: state.pageKey);
                      },
                      routes: [
                        GoRoute(
                          path: Routes.accountInfo.path,
                          pageBuilder: (context, state) {
                            return buildPageWithCupertinoTransition(
                              context: context,
                              state: state,
                              child: AccountInfoScreen(key: state.pageKey),
                            );
                          },
                        ),
                        GoRoute(
                          path: Routes.changePassword.path,
                          pageBuilder: (context, state) {
                            return buildPageWithCupertinoTransition(
                              context: context,
                              state: state,
                              child: ChangePasswordScreen(key: state.pageKey),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            GoRoute(
              path: Routes.splash.path,
              pageBuilder: (context, state) {
                return buildPageWithCupertinoTransition(
                  context: context,
                  state: state,
                  child: SplashScreen(key: state.pageKey),
                );
              },
            ),

            GoRoute(
              path: Routes.login.path,
              pageBuilder: (context, state) {
                return buildPageWithCupertinoTransition(
                  context: context,
                  state: state,
                  child: LoginScreen(key: state.pageKey),
                );
              },
            ),

            GoRoute(
              path: Routes.browse.path,
              pageBuilder: (context, state) {
                return buildPageWithCupertinoTransition(
                  context: context,
                  state: state,
                  child: CatalogScreen(key: state.pageKey, guest: true),
                );
              },
            ),

            // Pushed from several tabs, so outside the branches (see
            // app_routes.dart).
            _pushed(
              Routes.productDetails.path,
              (state) => ProductDetailsScreen(
                key: state.pageKey,
                uid: state.pathParameters['uid'] ?? '',
              ),
            ),
            _pushed(
              Routes.cart.path,
              (state) => CartScreen(key: state.pageKey),
            ),
            _pushed(
              Routes.orderDetails.path,
              (state) => OrderDetailsScreen(
                key: state.pageKey,
                uid: state.pathParameters['uid'] ?? '',
              ),
            ),
            _pushed(
              Routes.saleDetails.path,
              (state) => SaleDetailsScreen(
                key: state.pageKey,
                uid: state.pathParameters['uid'] ?? '',
              ),
            ),
            _pushed(
              Routes.deliveryNoteDetails.path,
              (state) => DeliveryNoteDetailsScreen(
                key: state.pageKey,
                uid: state.pathParameters['uid'] ?? '',
              ),
            ),
          ],
        ),
      ],
    );
  }

  static GoRoute _pushed(String path, Widget Function(GoRouterState) build) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) {
        return buildPageWithCupertinoTransition(
          context: context,
          state: state,
          child: build(state),
        );
      },
    );
  }

  static String _loginWithTarget(String target) => Uri(
    path: Routes.login.route,
    queryParameters: {'from': target},
  ).toString();

  static bool _isPublicRoutes(String location) {
    return [Routes.login.route, Routes.splash.route].contains(location);
  }

  /// Open to signed-out users too: the guest catalogue and a product page
  /// (`/product/<uid>`, exactly one segment after the prefix).
  static bool _isGuestRoutes(String location) {
    if (location == Routes.browse.route) return true;
    final prefix = Routes.productDetails.route(uid: '');
    if (!location.startsWith(prefix)) return false;
    final rest = location.substring(prefix.length);
    return rest.isNotEmpty && !rest.contains('/');
  }
}
