import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';
import 'package:agrifober_resellers/features/catalog/presentation/widgets/add_to_cart_sheet.dart';
import 'package:agrifober_resellers/features/catalog/presentation/widgets/guest_price_notice.dart';
import 'package:agrifober_resellers/features/catalog/presentation/widgets/product_card.dart';

/// Product card of the Accueil strip and the Catalogue grid: photo, name,
/// prices, and "+ Ajouter" (opens the quantity sheet) / `− 2 +` bound to the
/// cart by the caller. Tapping it opens the product.
class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    this.width = double.infinity,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
    this.showPrice = true,
  });

  final Product product;
  final double width;
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  /// False in guest mode ([Catalog.pricesVisible]): the prices give way to
  /// [GuestPriceNotice] and "Ajouter" to "Se connecter".
  final bool showPrice;

  // Fixed geometry so every card lines up (home strip, catalogue grid): image
  // block, a 2-line name slot, price, retail price, then the add control.
  static const _imageHeight = 112.0;
  static const _nameHeight = 38.0;
  static const _controlHeight = 34.0;
  static const _retailHeight = 16.0;
  static const height =
      AppSpacing.xs + // top inset
      _imageHeight +
      AppSpacing.xs +
      _nameHeight +
      AppSpacing.xxs +
      20 +
      _retailHeight +
      AppSpacing.xs +
      _controlHeight +
      AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.tiny);

    return Container(
      decoration: BoxDecoration(borderRadius: radius),
      child: Material(
        color: AppColors.white,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () =>
              context.push(Routes.productDetails.route(uid: product.uid)),
          child: Container(
            width: width,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              AppSpacing.xs,
              AppSpacing.xs,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xxs,
                    AppSpacing.xs,
                    AppSpacing.xxs,
                    AppSpacing.xs,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: _nameHeight,
                        child: TextUI(
                          product.name,
                          maxLines: 2,
                          style: CustomTextStyle(
                            fontSize: AppFontSize.xs + 1,
                            fontWeight: AppFontWeight.medium,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      if (!showPrice)
                        // Same height as the two price lines below.
                        const SizedBox(
                          height: 20 + _retailHeight,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GuestPriceNotice(
                              fontSize: AppFontSize.xxs + 1,
                            ),
                          ),
                        )
                      else ...[
                        SizedBox(
                          height: 20,
                          child: TextUI(
                            Helpers.formatMad(product.resellerPrice),
                            maxLines: 1,
                            style: CustomTextStyle(
                              fontSize: AppFontSize.base,
                              fontWeight: AppFontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _retailHeight,
                          child: product.retailPrice == null
                              ? null
                              : TextUI(
                                  'Prix public : ${Helpers.formatMad(product.retailPrice!)}',
                                  maxLines: 1,
                                  style: CustomTextStyle(
                                    fontSize: AppFontSize.xxs + 1,
                                    color: AppColors.black54,
                                  ),
                                ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xs),
                      _buildControl(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// White inset panel for the photo (product shots are on white). The
  /// margin badge is kept for the product screen.
  Widget _buildImage() {
    return Container(
      height: _imageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Center(
        child: ProductImage(product: product, size: _imageHeight - 16),
      ),
    );
  }

  /// Light green "+ Ajouter" until the product is in the cart, then a solid
  /// green `− 2 +`. Both "Ajouter" and the quantity open the quantity sheet.
  Widget _buildControl(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.small);

    if (qty == 0 || !showPrice) {
      return Material(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: radius,
        child: InkWell(
          onTap: () => showPrice
              ? showAddToCartSheet(context, product)
              : pushSignIn(context),
          borderRadius: radius,
          child: SizedBox(
            height: _controlHeight,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppSpacing.xxs,
              children: [
                (showPrice ? AppIcons.plusSmallRR : AppIcons.lockRR)(
                  color: AppColors.primary,
                  size: showPrice ? AppFontSize.base : AppFontSize.sm,
                ),
                TextUI(
                  showPrice ? 'Ajouter' : 'Se connecter',
                  style: CustomTextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Once added: the filled brand green marks "in the cart".
    return Container(
      height: _controlHeight,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: radius),
      child: Row(
        children: [
          _stepButton(AppIcons.minusSmallRR, onDecrement),
          Expanded(
            child: InkWell(
              onTap: () => showAddToCartSheet(context, product),
              child: SizedBox(
                height: _controlHeight,
                child: Center(
                  child: TextUI(
                    '$qty',
                    textAlign: CustomTextAlign.center,
                    style: CustomTextStyle(
                      fontSize: AppFontSize.base,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _stepButton(AppIcons.plusSmallRR, onIncrement),
        ],
      ),
    );
  }

  Widget _stepButton(AppIcon icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: SizedBox(
        width: _controlHeight,
        height: _controlHeight,
        child: Center(
          child: icon(color: AppColors.white, size: AppFontSize.lg),
        ),
      ),
    );
  }
}
