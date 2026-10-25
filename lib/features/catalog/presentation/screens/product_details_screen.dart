import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';
import 'package:agrifober_resellers/features/catalog/presentation/providers/index.dart';
import 'package:agrifober_resellers/features/catalog/presentation/widgets/index.dart';
import 'package:agrifober_resellers/features/orders/presentation/providers/index.dart';

/// One product of the catalogue: large photo, price, the revendeur's margin,
/// description, and a fixed bottom bar to add it to the cart. Read from the
/// already-loaded catalogue — there is no per-product endpoint.
class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({super.key, required this.uid});

  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(catalogProvider);

    final product = catalog.value?.products
        .where((p) => p.uid == uid)
        .firstOrNull;

    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: const MainAppBar(title: 'Produit'),
      body: catalog.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: AppColors.primary,
          ),
        ),
        error: (error, _) => ErrorStateUI(
          error: error,
          onRetry: () => ref.invalidate(catalogProvider),
        ),
        data: (catalog) {
          if (product == null) {
            return EmptyStateUI(
              icon: AppIcons.boxRR,
              title: 'Produit introuvable',
              description: 'Ce produit n\'est plus disponible à la commande.',
            );
          }
          final category = catalog.categories
              .where((c) => c.uid == product.categoryUid)
              .firstOrNull;
          return _ProductBody(
            product: product,
            category: category,
            showPrice: catalog.pricesVisible,
          );
        },
      ),
      bottomNavigationBar: product == null
          ? null
          : catalog.value?.pricesVisible == false
          ? const _SignInBar()
          : _AddToCartBar(product: product),
    );
  }
}

class _ProductBody extends ConsumerWidget {
  const _ProductBody({
    required this.product,
    required this.category,
    required this.showPrice,
  });

  final Product product;
  final ProductCategory? category;

  /// False in guest mode: the public catalogue has no prices (so no margin
  /// either — [Product.unitMargin] is null).
  final bool showPrice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qty = ref.watch(cartProvider)[product.uid]?.qty ?? 0;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ProductPhotoSlider(product: product),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (category != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.circle),
                  ),
                  child: TextUI(
                    category!.name,
                    style: CustomTextStyle(
                      fontSize: AppFontSize.xs,
                      fontWeight: AppFontWeight.medium,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              TextUI(
                product.name,
                style: CustomTextStyle(
                  fontSize: AppFontSize.xxl,
                  fontWeight: AppFontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              showPrice
                  ? _buildPrices()
                  : const GuestPriceNotice(fontSize: AppFontSize.sm),
              if (product.unitMargin != null) ...[
                const SizedBox(height: AppSpacing.base),
                _buildMargin(qty),
              ],
              if (product.description.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.base),
                _buildDescription(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrices() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextUI(
          Helpers.formatMad(product.resellerPrice),
          style: CustomTextStyle(
            fontSize: AppFontSize.xl3,
            fontWeight: AppFontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        if (product.retailPrice != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: TextUI(
                'Prix public conseillé ${Helpers.formatMad(product.retailPrice!)}',
                style: CustomTextStyle(
                  fontSize: AppFontSize.xs,
                  color: AppColors.black54,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// What the revendeur earns: per unit, and for the quantity in the cart.
  Widget _buildMargin(int qty) {
    final margin = product.unitMargin!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.tiny),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AppIcons.chartRR(
                color: AppColors.primary,
                size: AppFontSize.base,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUI(
                  'Votre marge : ${Helpers.formatMad(margin)} par unité (${Helpers.formatPercent(product.marginRate!)})',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                TextUI(
                  qty == 0
                      ? 'En revendant au prix public conseillé.'
                      : 'Pour $qty unité${qty > 1 ? 's' : ''} : ${Helpers.formatMad(margin * qty)}',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.xs,
                    color: AppColors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.tiny),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextUI(
            'Description',
            style: CustomTextStyle(
              fontSize: AppFontSize.base,
              fontWeight: AppFontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextUI(
            product.description,
            style: CustomTextStyle(
              fontSize: AppFontSize.sm,
              color: AppColors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// Guest mode's bottom bar: sign in to see the price and order.
class _SignInBar extends StatelessWidget {
  const _SignInBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.gray)),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: ButtonUI(
          onPressed: () => pushSignIn(context),
          text: 'Se connecter pour voir le prix',
          icon: AppIcons.lockRR,
          textSize: AppFontSize.base,
          minHeight: 48,
        ),
      ),
    );
  }
}

/// Fixed bottom bar: "Ajouter au panier" until added, then the quantity
/// stepper next to "Voir le panier".
class _AddToCartBar extends ConsumerWidget {
  const _AddToCartBar({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final qty = cart[product.uid]?.qty ?? 0;
    final notifier = ref.read(cartProvider.notifier);

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.gray)),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: qty == 0
            ? ButtonUI(
                onPressed: () => notifier.increment(product),
                text:
                    'Ajouter au panier · ${Helpers.formatMad(product.resellerPrice)}',
                icon: AppIcons.cartRR,
                textSize: AppFontSize.base,
                minHeight: 48,
              )
            : Row(
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(AppRadius.tiny),
                    ),
                    child: Row(
                      children: [
                        _stepButton(
                          AppIcons.minusSmallRR,
                          () => notifier.decrement(product),
                        ),
                        SizedBox(
                          width: 32,
                          child: TextUI(
                            '$qty',
                            textAlign: CustomTextAlign.center,
                            style: CustomTextStyle(
                              fontSize: AppFontSize.lg,
                              fontWeight: AppFontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        _stepButton(
                          AppIcons.plusSmallRR,
                          () => notifier.increment(product),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ButtonUI(
                      onPressed: () => context.push(Routes.cart.route),
                      text: 'Voir le panier (${cart.itemsCount})',
                      textSize: AppFontSize.base,
                      minHeight: 48,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _stepButton(AppIcon icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.tiny),
      child: SizedBox(
        width: 44,
        height: 48,
        child: Center(
          child: icon(color: AppColors.primary, size: AppFontSize.xl),
        ),
      ),
    );
  }
}
