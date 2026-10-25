class Routes {
  static final splash = _StaticRouteManager(path: '/splash', route: '/splash');
  static final login = _StaticRouteManager(path: '/login', route: '/login');

  /// Guest mode: the catalogue without prices, reachable signed out (login's
  /// "Voir le catalogue"). Signed in, it redirects to [catalog].
  static final browse = _StaticRouteManager(path: '/browse', route: '/browse');

  // ── Bottom-nav tabs (one StatefulShellBranch each) ──────────────────────────

  static final home = _StaticRouteManager(path: '/home', route: '/home');

  /// The shop: front and centre so ordering is one tap away.
  static final catalog = _StaticRouteManager(
    path: '/catalog',
    route: '/catalog',
  );

  static final history = _StaticRouteManager(
    path: '/history',
    route: '/history',
  );

  /// Query key selecting the Historique segment (see [HistoryTab]).
  static const historyTabQueryKey = 'tab';

  /// `/history?tab=orders` — Historique opened on a given segment.
  static String historyTab(HistoryTab tab) => Uri(
    path: history.route,
    queryParameters: {historyTabQueryKey: tab.queryValue},
  ).toString();

  static final credit = _StaticRouteManager(path: '/credit', route: '/credit');

  static final profile = _StaticRouteManager(
    path: '/profile',
    route: '/profile',
  );

  static final accountInfo = _StaticRouteManager(
    path: 'account',
    route: '/profile/account',
  );

  static final changePassword = _StaticRouteManager(
    path: 'change-password',
    route: '/profile/change-password',
  );

  // ── Pushed screens ─────────────────────────────────────────────────────────
  // Reached from several tabs (home's recent activity, history, credit…), so
  // they sit outside the branches rather than under one of them: pushing a
  // branch's own child from another tab puts the shell's page in two
  // navigators and trips go_router's duplicate-page-key assertion.

  static final productDetails = _DynamicRouteManager(
    path: '/product/:uid',
    route: ({required String uid}) => '/product/$uid',
  );

  static final cart = _StaticRouteManager(path: '/cart', route: '/cart');

  static final orderDetails = _DynamicRouteManager(
    path: '/order/:uid',
    route: ({required String uid}) => '/order/$uid',
  );

  static final saleDetails = _DynamicRouteManager(
    path: '/sale/:uid',
    route: ({required String uid}) => '/sale/$uid',
  );

  static final deliveryNoteDetails = _DynamicRouteManager(
    path: '/delivery-note/:uid',
    route: ({required String uid}) => '/delivery-note/$uid',
  );
}

/// Segments of the Historique tab, in display order.
enum HistoryTab {
  orders('orders'),
  sales('sales'),
  deliveryNotes('delivery-notes'),
  invoices('invoices');

  const HistoryTab(this.queryValue);

  final String queryValue;

  static HistoryTab? fromQuery(String? value) {
    for (final tab in values) {
      if (tab.queryValue == value) return tab;
    }
    return null;
  }
}

typedef _RouteUID = String Function({required String uid});
typedef _Route = String;

class _RouteManager {
  final String path;

  _RouteManager({required this.path});
}

class _DynamicRouteManager extends _RouteManager {
  final _RouteUID route;

  _DynamicRouteManager({required super.path, required this.route});
}

class _StaticRouteManager extends _RouteManager {
  final _Route route;

  _StaticRouteManager({required super.path, required this.route});
}
