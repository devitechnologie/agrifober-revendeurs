import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// local imports
import 'package:agrifober_resellers/config/config.dart';
import 'package:agrifober_resellers/core/core.dart';
import 'package:agrifober_resellers/shared/shared.dart';
import 'package:agrifober_resellers/features/catalog/domain/domain.dart';

/// Catalogue row: image, name, reseller price (+ "Prix public conseillé" and
/// the revendeur's margin when set) and a quantity stepper bound to the cart
/// by the caller. Tapping it opens the product.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
  });

  final Product product;
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.productDetails.route(uid: product.uid)),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.gray)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(product: product, size: 72),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUI(
                    product.name,
                    maxLines: 2,
                    style: CustomTextStyle(
                      fontSize: AppFontSize.base,
                      fontWeight: AppFontWeight.medium,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  TextUI(
                    Helpers.formatMad(product.resellerPrice),
                    style: CustomTextStyle(
                      fontSize: AppFontSize.base,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (product.retailPrice != null)
                    TextUI(
                      'Prix public conseillé : ${Helpers.formatMad(product.retailPrice!)}',
                      style: CustomTextStyle(
                        fontSize: AppFontSize.xs,
                        color: AppColors.black54,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: QuantityStepperUI(
                      value: qty,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product photo with a box placeholder (no image, loading or broken URL).
/// Shows the cover unless [url] picks another of the product's photos.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    required this.size,
    this.url,
  });

  final Product product;
  final double size;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Center(
        child: AppIcons.boxRR(color: AppColors.black54, size: size * 0.4),
      ),
    );

    final src = url ?? product.imageUrl;
    if (src.isEmpty) return placeholder;
    return ImageUI.network(
      url: src,
      width: size,
      height: size,
      fit: BoxFit.contain,
      borderRadius: BorderRadius.circular(AppRadius.small),
      placeholder: placeholder,
      errorWidget: placeholder,
    );
  }
}

/// "Votre marge : 200,00 MAD (22 %)" — what the revendeur earns per unit at
/// the recommended retail price. Only built when the product has a margin.
class MarginChip extends StatelessWidget {
  const MarginChip({super.key, required this.product, this.compact = false});

  final Product product;

  /// "Marge 22 %" only, for the narrow cards of the home strip.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final margin = product.unitMargin!;
    final rate = Helpers.formatPercent(product.marginRate!);
    final text = compact
        ? 'Marge $rate'
        : 'Votre marge : ${Helpers.formatMad(margin)} ($rate)';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.circle),
      ),
      child: TextUI(
        text,
        maxLines: 1,
        style: CustomTextStyle(
          fontSize: AppFontSize.xs,
          fontWeight: AppFontWeight.medium,
          color: AppColors.green,
        ),
      ),
    );
  }
}
