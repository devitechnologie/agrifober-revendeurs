import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';
import 'package:agrifober_resellers/features/catalog/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/catalog/presentation/widgets/index.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/orders/presentation/widgets/cart_bar.dart';

/// "Catalogue" tab: the shop. Pick products and quantities, then the cart
/// bar leads to the commande.
///
/// [guest]: the signed-out `/browse` screen (from login's "Voir le
/// catalogue") — no tabs, no cart, no prices, and a "Se connecter" button.
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key, this.guest = false});

  final bool guest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);

    return Scaffold(
      // The cart bar floats: the grid scrolls behind it.
      extendBody: true,
      backgroundColor: AppColors.accent,
      // bottom: false — with extendBody the bottom inset includes the cart
      // bar, and padding for it would stop the grid above the bar again. The
      // grid reserves its own room for the bar (_cartBarClearance).
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarHeader(
              title: 'Catalogue',
              action: guest ? const _SignInButton() : null,
            ),
            Expanded(
              child: catalog.when(
                skipLoadingOnRefresh: true,
                loading: () => Skeletonizer(
                  effect: const ShimmerEffect(baseColor: AppColors.accent),
                  child: _CatalogBody(catalog: CatalogMock.skeleton()),
                ),
                error: (error, _) => ErrorStateUI(
                  error: error,
                  onRetry: () => ref.invalidate(catalogProvider),
                ),
                data: (catalog) => _CatalogBody(catalog: catalog),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: guest ? null : const CartBar(),
    );
  }
}

/// Header pill of the guest catalogue.
class _SignInButton extends StatelessWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.circle);
    return Material(
      color: AppColors.primary,
      borderRadius: radius,
      child: InkWell(
        onTap: () => pushSignIn(context),
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: TextUI(
            'Se connecter',
            style: CustomTextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: AppFontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Height of the floating [CartBar] plus a little air.
const _cartBarClearance = 96.0;

class _CatalogBody extends ConsumerWidget {
  const _CatalogBody({required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(catalogQueryProvider).trim().toLowerCase();
    final categoryUid = ref.watch(catalogCategoryProvider);
    final cart = ref.watch(cartProvider);

    final products = catalog.products.where((p) {
      if (categoryUid != null && p.categoryUid != categoryUid) return false;
      return query.isEmpty || p.name.toLowerCase().contains(query);
    }).toList();

    // The search bar stays put above the scrolling grid.
    return Column(
      children: [
        Padding(
          // No top padding: every tab's content starts right under the
          // AppBarHeader (its own bottom spacing is the gap).
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            0,
            AppSpacing.base,
            AppSpacing.sm,
          ),
          child: TextFieldUI(
            hintText: 'Rechercher un produit',
            defaultValue: ref.read(catalogQueryProvider),
            useClearButton: true,
            prefix: AppIcons.searchRR(
              color: AppColors.black54,
              size: AppFontSize.lg,
            ),
            onChanged: ref.read(catalogQueryProvider.notifier).set,
          ),
        ),
        Expanded(
          child: _buildScrollable(
            ref,
            catalog,
            products,
            query,
            categoryUid,
            cart,
          ),
        ),
      ],
    );
  }

  Widget _buildScrollable(
    WidgetRef ref,
    Catalog catalog,
    List<Product> products,
    String query,
    String? categoryUid,
    Map<String, CartItem> cart,
  ) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => ref.refresh(catalogProvider.future),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        // Typing in the search field shouldn't fight with the grid scroll.
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // A single category needs no filter chips.
          if (catalog.categories.length > 1)
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                ),
                child: Row(
                  spacing: AppSpacing.xs,
                  children: [
                    _categoryChip(
                      ref,
                      label: 'Tous',
                      uid: null,
                      selected: categoryUid,
                    ),
                    for (final category in catalog.categories)
                      _categoryChip(
                        ref,
                        label: category.name,
                        uid: category.uid,
                        selected: categoryUid,
                      ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                AppSpacing.base,
                AppSpacing.base,
                AppSpacing.sm,
              ),
              child: TextUI(
                Helpers.plural(products.length, 'produit'),
                style: CustomTextStyle(
                  fontSize: AppFontSize.sm,
                  color: AppColors.black54,
                ),
              ),
            ),
          ),
          if (products.isEmpty)
            SliverToBoxAdapter(
              child: EmptyStateUI(
                icon: AppIcons.boxRR,
                title: 'Aucun produit',
                description: query.isEmpty
                    ? 'Aucun produit disponible à la commande.'
                    : 'Aucun produit ne correspond à « $query ».',
              ),
            )
          else
            SliverPadding(
              // Room under the last row so it can scroll above the floating
              // cart bar.
              padding: EdgeInsets.fromLTRB(
                AppSpacing.base,
                0,
                AppSpacing.base,
                cart.isEmpty ? AppSpacing.base : _cartBarClearance,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisExtent: ProductGridCard.height,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductGridCard(
                    product: product,
                    showPrice: catalog.pricesVisible,
                    qty: cart[product.uid]?.qty ?? 0,
                    onIncrement: () =>
                        ref.read(cartProvider.notifier).increment(product),
                    onDecrement: () =>
                        ref.read(cartProvider.notifier).decrement(product),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _categoryChip(
    WidgetRef ref, {
    required String label,
    required String? uid,
    required String? selected,
  }) {
    final isSelected = uid == selected;
    return ChipUI(
      text: label,
      onPressed: () => ref.read(catalogCategoryProvider.notifier).set(uid),
      backgroundColor: isSelected ? AppColors.primary : AppColors.white,
      textColor: isSelected ? AppColors.white : AppColors.black,
      borderColor: isSelected ? AppColors.primary : AppColors.gray500,
    );
  }
}
