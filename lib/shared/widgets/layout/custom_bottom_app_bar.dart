import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/shared/widgets/ui/index.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/cart_provider.dart';

typedef _NavItem = ({
  AppIcon iconFill,
  AppIcon iconLine,
  String label,
  int branchIndex,
  String route,
});

class CustomBottomAppBar extends ConsumerStatefulWidget {
  const CustomBottomAppBar({super.key, required this.navShell});

  final StatefulNavigationShell navShell;

  @override
  ConsumerState<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends ConsumerState<CustomBottomAppBar> {
  late int _selectedIndex;
  static final Set<String> _bottomNavigationRoutes = {
    Routes.home.path,
    Routes.catalog.path,
    Routes.history.path,
    Routes.credit.path,
    Routes.profile.path,
  };

  // Every tab needs a signed-in revendeur; the router never lets a guest in.
  static final List<_NavItem> _items = [
    (
      iconFill: AppIcons.homeActive,
      iconLine: AppIcons.homeInactive,
      label: 'Accueil',
      route: Routes.home.route,
      branchIndex: 0,
    ),
    (
      iconFill: AppIcons.cartActive,
      iconLine: AppIcons.cartInactive,
      label: 'Catalogue',
      route: Routes.catalog.route,
      branchIndex: 1,
    ),
    (
      iconFill: AppIcons.historyActive,
      iconLine: AppIcons.historyInactive,
      label: 'Historique',
      route: Routes.history.route,
      branchIndex: 2,
    ),
    (
      iconFill: AppIcons.creditActive,
      iconLine: AppIcons.creditInactive,
      label: 'Crédit',
      route: Routes.credit.route,
      branchIndex: 3,
    ),
    (
      iconFill: AppIcons.userActive,
      iconLine: AppIcons.userInactive,
      label: 'Profil',
      route: Routes.profile.route,
      branchIndex: 4,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.navShell.currentIndex;
  }

  @override
  void didUpdateWidget(covariant CustomBottomAppBar oldWidget) {
    if (widget.navShell.currentIndex != oldWidget.navShell.currentIndex) {
      setState(() {
        _selectedIndex = widget.navShell.currentIndex;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _goToScreen(_NavItem item) {
    setState(() {
      _selectedIndex = item.branchIndex;
    });

    widget.navShell.goBranch(
      item.branchIndex,
      initialLocation: item.branchIndex == widget.navShell.currentIndex,
    );
  }

  bool _shouldBuildBottomNavigation(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    return _bottomNavigationRoutes.contains(currentPath);
  }

  @override
  Widget build(BuildContext context) {
    final shouldBuildBottomNavigation = _shouldBuildBottomNavigation(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: widget.navShell,
      ),
      bottomNavigationBar: shouldBuildBottomNavigation
          ? _buildBottomNavigation()
          : null,
    );
  }

  Widget _buildBottomNavigation() {
    return BottomAppBar(
      color: AppColors.white,
      padding: EdgeInsets.zero,
      height: 64.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.gray, width: 1.0)),
        ),
        child: Row(
          children: [
            for (final item in _items)
              _navItem(
                item,
                // Products waiting in the cart, on the Catalogue tab.
                notification: item.route == Routes.catalog.route
                    ? ref.watch(cartProvider).itemsCount
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(_NavItem item, {int? notification}) {
    final index = item.branchIndex;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _goToScreen(item),
          splashColor: AppColors.primary.withValues(alpha: 0.10),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _selectedIndex == index
                      ? item.iconFill(color: AppColors.primary, size: 20.0)
                      : item.iconLine(color: AppColors.black87, size: 20.0),
                  if (notification != null && notification > 0)
                    Positioned(
                      top: -5.0,
                      right: -8.0,
                      // A pill that grows with "9+" instead of a fixed circle.
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 16.0,
                          minHeight: 16.0,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(AppRadius.circle),
                          border: Border.all(
                            color: AppColors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: TextUI(
                            notification > 9 ? '9+' : notification.toString(),
                            style: CustomTextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              TextUI(
                item.label,
                maxLines: 1,
                style: CustomTextStyle(
                  color: _selectedIndex == index
                      ? AppColors.primary
                      : AppColors.black87,
                  fontSize: AppFontSize.sm - 1,
                  fontWeight: AppFontWeight.regular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
